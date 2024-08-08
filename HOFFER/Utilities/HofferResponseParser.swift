
class HofferResponseParser {
    static let instance = HofferResponseParser()
    
    
    enum Response: CustomDebugStringConvertible {
        case DA(Array<String>)
        case US(UInt32)
        case AA(r: Double, t1: Double, gt: Double, t2_unit: String, t2: Double, p_unit: String, p: Double)
        case Unknown(String)
        case IncompleteCommand
        var debugDescription: String {
            get {
                var result: String
                switch self {
                case let .DA(lines): do {
                    result = "DAResponse [\n"
                    for line in lines {
                        result += "  \(line.debugDescription)\n"
                    }
                    result += "]\n"
                }
                case .US(let code): do {
                    result = String(format: "US(%08X)\n", code)
                }
                case let .AA(r, t1, gt, t2_unit, t2, p_unit, p): do {
                    result = String(format: "r=%f t1=%f gt=%f t2_unit=%@ t2=%f p_unit=%@ p=%f", r, t1, gt, Utilities.debugEscape(t2_unit), t2, Utilities.debugEscape(p_unit), p)
                }
                case .Unknown(let line): do {
                    result = "Unknown: \(line.debugDescription)"
                }
                case .IncompleteCommand: do {
                    result = "IncompleteCommand"
                }
                }
                return result
            }
        }
    }
    
    // should only be called when running on our queue
    private func addResponse(_ response: Response) {
        let RESPONSES_MAX = 40;
        responses.append(response)
        print("HofferResponseParser got \(response.debugDescription)")
        if responses.count > RESPONSES_MAX {
            let extra = responses.count - RESPONSES_MAX
            responses.removeSubrange(0..<extra)
        }
    }
    // safe to call from anywhere
    public func getResponse() -> Response? {
        return queue.sync(flags: .barrier, execute: {
            if self.responses.isEmpty {
                return nil as Response?
            } else {
                return self.responses.removeFirst()
            }
        })
    }

    // These private members must only be accessed through the queue!
    private final var responses: Array<Response> = Array()
    private let queue = DispatchQueue(label: "HofferResponseParserQueue", attributes: .concurrent)

    private final var lineBuilder = ""
    private var skipNewline = false
    private final var lineQueue: [String] = []

    // takes the input packet bytes and adds them onto the line builder
    public func receivedBytes(_ inBytes: Data) {
        queue.async(flags: .barrier) {
            if let string = String(bytes: inBytes, encoding: .ascii) {
                self.lineBuilder.append(string)
                self.processLineInput()
            }
        }
    }
    // Finds all the complete lines in the line builder and appends them onto lineQueue;
    // Must only be called while within queue.async!
    private func processLineInput() {
        //let CHATTER = lineBuilder.count > 0 && lineBuilder[lineBuilder.startIndex] == "U"
        var idx = lineBuilder.startIndex
        /* I'm writing this to handle line breaks as being "\n\r",
           "\r\n", "\n", or "\r".  The Hoffer device's DA response
           contains both "\r\n" and "\n\r" line endings.
         */
        var addedLine = false;
        while (idx < lineBuilder.endIndex  ) {
            let c: Character = lineBuilder[idx]
            
            if (skipNewline && idx == lineBuilder.startIndex && (c == "\r" || c == "\n" || c == "\r\n")) {
                lineBuilder.removeFirst()
                idx = lineBuilder.startIndex
                // we've seen a second CR or LF, so any more CR of LF
                // should be part of an additional logical newline
                if (c == "\r\n") {
                    // we already saw a "\n", this "\r\n" is the second character of the end of the last line (already queued), and the first character of a blank line coming up.  Apple smushed together the wrong two characters.
                    skipNewline = true
                } else {
                    // The previous line is done, any more newline characters mean it was a blank line
                    skipNewline = false
                }
                
            } else if (c == "\r\n" || c == "\n" || c == "\r") {
                // chars 0 through idx-1 make a line
                let line = String(lineBuilder[lineBuilder.startIndex..<idx]);
                lineQueue.append(line)
                addedLine = true;
                // deletes all characters up to and including '\n'
                lineBuilder.removeSubrange(lineBuilder.startIndex...idx);
                idx = lineBuilder.startIndex;
                // reminder to skip extra '\r' or '\n' later
                // "\r\n" is tricky.  It means we got a whole newline pair and
                // shouldn't skipNewline next line.
                skipNewline = (c != "\r\n");
            } else {
                skipNewline = false; // we've seen a non-newline character
                idx = lineBuilder.index(after: idx);
            }
        }
        if (addedLine) {
            parseLines();
        }
    }
    private enum ParserState {
        case S_IN_BETWEEN
        case S_DA(lines: [String])
        public var debugDescription: String {
            get {
                let result: String;
                switch self {
                    case .S_IN_BETWEEN: result = "S_IN_BETWEEN"
                    case .S_DA(_): result = "S_DA(...)"
                }
                return result
            }
        }
    }
    private var parserState = ParserState.S_IN_BETWEEN;
    private static let patNum: String = "\\s*([+-]?[\\d.]+)\\s*";
    private final var patDAStart = try! NSRegularExpression(pattern: "^DA$")
    private final var patDAEnd = try! NSRegularExpression(pattern:"^End of Configuration Printout$")
    private final var patUS_1 = try! NSRegularExpression(pattern: "^US$")
    private final var patUS_2 = try! NSRegularExpression(pattern: "^UNIT STATUS\\s+=" + patNum + "$")
    private final var patAA_1 = try! NSRegularExpression(pattern: "^AA$")
    private final var patAutoDataOff = try! NSRegularExpression(pattern: "^Turning Auto Data OFF$")
    // "R=    0.0  T=   532.3  GT=   351747  T(K)=  73.1  P(psig)= 235.3\n\r"
    private final var patAA_2 = try! NSRegularExpression(pattern: "^R=" + patNum + "T=" + patNum + "GT=" + patNum + "T\\(([^)]+)\\)=" + patNum + "P\\(([^)]+)\\)=" + patNum + "$" )
    private final var patIC = try! NSRegularExpression(pattern: "^Incomplete Command$")
    private final let TAG = "HofferResponseParser"

    private func parseLines() {
        while !lineQueue.isEmpty {
            let line = lineQueue.removeFirst()
            let range = NSRange(line.startIndex..<line.endIndex, in: line)
            print("\(TAG) parsing \(line.debugDescription)")
            print("\(TAG) startOfLoop parserState=\(parserState.debugDescription)")
            if let _ = patAutoDataOff.firstMatch(in: line, range: range) {
                // this is fine
                continue;
            }
            if let r = matchAALine(line: line, range: range) {
                addResponse(r)
                parserState = .S_IN_BETWEEN
                continue;
            }
            switch (parserState) {
            case .S_IN_BETWEEN: do {
                if let _ = patDAStart.firstMatch(in: line, range: range) {
                    let lines = [line]
                    parserState = ParserState.S_DA(lines: lines)
                } else if let _ = patUS_1.firstMatch(in: line, range: range) {
                    // fine, continue
                } else if let _ = patAA_1.firstMatch(in: line, range: range) {
                    continue // do nothing
                } else if let _ = patIC.firstMatch(in: line, range: range) {
                    addResponse(Response.IncompleteCommand)
                } else if let m = patUS_2.firstMatch(in: line, range: range) {
                    let codestr = (line as NSString).substring(with: m.range(at: 1))
                    if let code = UInt32(codestr) {
                        let r = Response.US(code)
                        addResponse(r)
                    } else {
                        addResponse(Response.Unknown(line))
                    }
                } else {
                    addResponse(Response.Unknown(line))
                }
                break;
            }
            case var .S_DA(lines: lines): do {
                if lines.count > 40 {
                    print("\(TAG) DA response was too long, giving up")
                    let r = Response.DA(lines)
                    addResponse(r)
                    parserState = .S_IN_BETWEEN
                } else if let _ = patDAEnd.firstMatch(in: line, range: range) {
                    lines.append(line)
                    let r = Response.DA(lines)
                    addResponse(r)
                    parserState = .S_IN_BETWEEN
                } else {
                    lines.append(line)
                }
                break
            }
            }
            print("\(TAG) endOfLoop parserState=\(parserState.debugDescription)")
        }
    }
    private func matchDouble(line: NSString, m: NSTextCheckingResult, at: Int) -> Double?
    {
        let str = line.substring(with: m.range(at: at))
        return Double(str)
    }
    private func matchAALine(line: String, range: NSRange) -> Response? {
        if let m = patAA_2.firstMatch(in: line, range: range) {
            let line = line as NSString
            let t2_unit = line.substring(with: m.range(at: 4))
            let p_unit = line.substring(with: m.range(at: 6))
            if let r = matchDouble(line:line, m:m, at: 1),
                let t1 = matchDouble(line:line, m:m, at: 2),
                let gt = matchDouble(line:line, m:m, at: 3),
                let t2 = matchDouble(line:line, m:m, at: 5),
                let p = matchDouble(line:line, m:m, at: 7)
            {
                return Response.AA(r: r, t1: t1, gt: gt, t2_unit: t2_unit, t2: t2, p_unit: p_unit, p: p)
            }
        }
        return nil
    }
}

