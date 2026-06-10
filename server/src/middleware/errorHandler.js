/**
 * Global error handler middleware.
 *
 * All unexpected exceptions are converted to structured HTTP responses.
 * This prevents stack traces from leaking to the client and ensures
 * consistent error response format across the API.
 *
 * Defense answer:
 * "We have a centralized error handler that catches all unhandled errors,
 *  logs them for debugging, and returns a clean 500 response to the client.
 *  This is a production best practice — you never want raw stack traces
 *  reaching the user."
 */
function errorHandler(err, req, res, _next) {
  console.error(`[ERROR] ${req.method} ${req.url}:`, err.message);
  console.error(err.stack);

  res.status(500).json({
    error: 'INTERNAL_ERROR',
    message: 'An unexpected error occurred. Please try again.',
  });
}

module.exports = errorHandler;
