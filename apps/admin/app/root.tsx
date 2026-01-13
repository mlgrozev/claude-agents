import {
  Links,
  Meta,
  Outlet,
  Scripts,
  ScrollRestoration,
  useLoaderData,
} from '@remix-run/react';
import { json, type LoaderFunctionArgs } from '@remix-run/cloudflare';
import { AppProvider } from '@shopify/polaris';
import '@shopify/polaris/build/esm/styles.css';

export async function loader({ request, context }: LoaderFunctionArgs) {
  const url = new URL(request.url);
  const shop = url.searchParams.get('shop');
  const host = url.searchParams.get('host');

  return json({
    shop,
    host,
    apiKey: (context.env as any).SHOPIFY_CLIENT_ID || '',
  });
}

export default function App() {
  const { shop, host, apiKey } = useLoaderData<typeof loader>();

  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link
          rel="stylesheet"
          href="https://unpkg.com/@shopify/polaris@12.0.0/build/esm/styles.css"
        />
        <Meta />
        <Links />
      </head>
      <body>
        <AppProvider i18n={{}}>
          <Outlet />
        </AppProvider>
        <ScrollRestoration />
        <Scripts />
      </body>
    </html>
  );
}

export function ErrorBoundary() {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Error - Redispute</title>
        <Meta />
        <Links />
      </head>
      <body>
        <div style={{ padding: '2rem', fontFamily: 'system-ui' }}>
          <h1>Something went wrong</h1>
          <p>We're sorry, but something went wrong. Please try again.</p>
        </div>
        <Scripts />
      </body>
    </html>
  );
}
