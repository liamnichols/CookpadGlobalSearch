import Vapor

// MARK: - URLSession+JSONDecoder
extension URLSession {

    func dataTask<R: Decodable>(with request: URLRequest,
                                expecting: R.Type,
                                completionHandler: @escaping (R?, URLResponse?, Error?) -> Void) -> URLSessionTask {

        return dataTask(with: request) { data, response, error in

            guard let data = data else {
                return completionHandler(nil, response, error)
            }

            do {

                let decoder = JSONDecoder()
                if #available(OSX 10.12, *) {
                    decoder.dateDecodingStrategy = .iso8601
                } else {
                    print("[App] [ERROR] macOS SDK < 10.12 detected, no ISO-8601 JSON support")
                }

                completionHandler(try decoder.decode(expecting, from: data), response, nil)
            } catch {
                completionHandler(nil, response, error)
            }
        }
    }
}

// MARK: - URLSession+Future
extension URLSession {

    func perform<R: Decodable>(request: URLRequest, in eventLoop: EventLoop, expecting _: R.Type) -> Future<R> {
        return perform(request: request, in: eventLoop)
    }

    func perform<R: Decodable>(request: URLRequest, in eventLoop: EventLoop) -> Future<R> {

        // Create the promise and link it with a data task
        let promise = eventLoop.newPromise(R.self)
        let task = dataTask(with: request, expecting: R.self) { decoded, response, error in
            if let decoded = decoded {
                promise.succeed(result: decoded)
            } else {
                promise.fail(error: error ?? Abort(.internalServerError))
            }
        }

        // Start the data task and return the future result
        task.resume()
        return promise.futureResult
    }
}
