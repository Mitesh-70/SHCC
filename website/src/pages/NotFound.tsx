import { Link } from 'react-router-dom';

export default function NotFound() {
  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 px-4">
      <div className="text-center">
        <h1 className="text-9xl font-black text-orange-500">404</h1>
        <p className="text-2xl font-bold text-gray-900 mt-4">Page not found</p>
        <p className="text-gray-500 mt-2">Sorry, we couldn't find the page you're looking for.</p>
        <div className="mt-6">
          <Link
            to="/"
            className="inline-flex items-center justify-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-orange-600 hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500"
          >
            Go back home
          </Link>
        </div>
      </div>
    </div>
  );
}
