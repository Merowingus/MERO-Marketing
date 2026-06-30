"use client";

import { useEffect, useState } from "react";
import { createClient } from "@/lib/supabase/client";

type Status = "idle" | "sending" | "sent" | "error";

export default function LoginPage() {
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState<Status>("idle");
  const [message, setMessage] = useState("");
  const [denied, setDenied] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    setDenied(params.get("denied") === "1");
  }, []);

  async function sendLink(e: React.FormEvent) {
    e.preventDefault();
    setStatus("sending");
    setMessage("");
    const supabase = createClient();
    const { error } = await supabase.auth.signInWithOtp({
      email: email.trim(),
      options: {
        emailRedirectTo: `${window.location.origin}/auth/callback`,
        shouldCreateUser: false,
      },
    });
    if (error) {
      setStatus("error");
      setMessage(error.message);
    } else {
      setStatus("sent");
    }
  }

  return (
    <main className="auth-wrap">
      <section className="auth-card">
        <div className="eyebrow">Merowingus Studio · MERO Marketing</div>
        <h1 className="auth-title">Command Center</h1>
        <p className="auth-lead">Owner access only. Sign in with your email — we&apos;ll send a one-time link.</p>

        {denied && (
          <p className="auth-note auth-note-warn">
            That account isn&apos;t allowed here. Sign in with the owner email.
          </p>
        )}

        {status === "sent" ? (
          <p className="auth-note auth-note-ok">
            Check <b>{email}</b> for the sign-in link. You can close this tab.
          </p>
        ) : (
          <form className="auth-form" onSubmit={sendLink}>
            <label htmlFor="email" className="auth-label">
              Email
            </label>
            <input
              id="email"
              type="email"
              required
              autoComplete="email"
              placeholder="you@example.com"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="auth-input"
            />
            <button
              type="submit"
              className="button auth-button"
              disabled={status === "sending"}
            >
              {status === "sending" ? "Sending…" : "Send sign-in link"}
            </button>
            {status === "error" && (
              <p className="auth-note auth-note-warn">{message}</p>
            )}
          </form>
        )}
      </section>
    </main>
  );
}
