import type { Metadata } from "next";
import "./dashboard.css";

export const metadata: Metadata = {
  title: "MERO Marketing Command Center",
  description: "Internal marketing command center — Merowingus Studio.",
  robots: { index: false, follow: false },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" data-theme="light">
      <body>{children}</body>
    </html>
  );
}
