import { json, badRequest, unauthorized } from "../_utils.js";

export async function onRequestPost({ request, env }) {
  const { password } = await request.json();
  if (!password) return badRequest("Password required");
  if (password !== env.ADMIN_PASSWORD) return unauthorized("Incorrect password");
  return json({ ok: true });
}
