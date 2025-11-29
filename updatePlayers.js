import fetch from "node-fetch";
import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = "https://phlzbzmgzgnkucauibhj.supabase.co";
const SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBobHpiem1nemdua3VjYXVpYmhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk4NDQ2ODgsImV4cCI6MjA3NTQyMDY4OH0.n0qn9vlEH_Q9GNL__nLJRP0OUdDvA8a9FR2En5tjDq8";
const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function updatePlayers() {
  console.log("⏳ Fetching players from Sleeper...");

  const res = await fetch("https://api.sleeper.app/v1/players/nfl");
  const data = await res.json();

  const allowedPositions = ["QB", "RB", "WR", "TE", "K"];
  const filteredPlayers = Object.values(data).filter(
    (p) =>
      allowedPositions.includes((p.position || "").toUpperCase()) &&
      p.team &&
      p.active !== false
  );

  console.log(`📊 Found ${filteredPlayers.length} valid NFL players.`);

  console.log("🧹 Clearing old players...");
  const { error: deleteError } = await supabase.from("players").delete().neq("id", "0");
  if (deleteError) {
    console.error("❌ Error clearing old players:", deleteError);
    return;
  }
  console.log("✅ Old players cleared.");

  for (let i = 0; i < filteredPlayers.length; i++) {
    const p = filteredPlayers[i];
    const playerData = {
      id: p.player_id.toString(),
      name: p.full_name || `${p.first_name || ""} ${p.last_name || ""}`.trim(),
      position: p.position,
      team: p.team,
      value: 0.0,
    };

    const { error } = await supabase.from("players").upsert(playerData, { onConflict: "id" });
    if (error) {
      console.error("❌ Error updating Supabase:", error);
    } else {
      if ((i + 1) % 20 === 0) console.log(`✅ Updated ${i + 1} players...`);
    }

    await sleep(200); // short delay to prevent overload
  }

  console.log("🎉 Done updating all players!");
}

updatePlayers().catch(console.error);
