import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import DashboardClient from "./DashboardClient";

// Server-side gate (defense in depth on top of middleware).
export default async function Page() {
  const supabase = createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  const owner = process.env.OWNER_EMAIL?.toLowerCase();

  if (!user || (owner && user.email?.toLowerCase() !== owner)) {
    redirect("/login");
  }

  return <DashboardClient />;
}
