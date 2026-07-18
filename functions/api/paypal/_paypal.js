// Talks to PayPal's REST API using server-side credentials only.
// PAYPAL_CLIENT_SECRET must NEVER be exposed to the browser — it lives only
// as a Pages Function environment secret.

export function paypalBase(env) {
  return env.PAYPAL_ENV === "live"
    ? "https://api-m.paypal.com"
    : "https://api-m.sandbox.paypal.com";
}

export async function getPaypalAccessToken(env) {
  const base = paypalBase(env);
  const creds = btoa(`${env.PAYPAL_CLIENT_ID}:${env.PAYPAL_CLIENT_SECRET}`);

  const res = await fetch(`${base}/v1/oauth2/token`, {
    method: "POST",
    headers: {
      Authorization: `Basic ${creds}`,
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: "grant_type=client_credentials",
  });

  if (!res.ok) {
    throw new Error(`PayPal auth failed: ${res.status} ${await res.text()}`);
  }
  const data = await res.json();
  return data.access_token;
}
