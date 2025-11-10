import fetch from "node-fetch";
import { createClient } from "@supabase/supabase-js";

// 🔑 Replace these with your Supabase values
const SUPABASE_URL = "https://phlzbzmgzgnkucauibhj.supabase.co";
const SUPABASE_SERVICE_ROLE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBobHpiem1nemdua3VjYXVpYmhqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk4NDQ2ODgsImV4cCI6MjA3NTQyMDY4OH0.n0qn9vlEH_Q9GNL__nLJRP0OUdDvA8a9FR2En5tjDq8"; // from Supabase → Project Settings → API

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

async function updatePlayers() {
  try {
    console.log("Fetching players from Sleeper API...");

    const res = await fetch("https://api.sleeper.app/v1/players/nfl");
    const data = await res.json();

    // Filter only relevant positions
    const positions = ["QB", "RB", "WR", "TE", "K"];
    const players = Object.values(data).filter(
      (p) => positions.includes(p.position)
    );

    console.log(`Found ${players.length} players. Updating Supabase...`);

    const formattedPlayers = players.map((p) => ({
      name: p.full_name,
      position: p.position,
      team: p.team,
      value: Math.random() * 100, // Placeholder value — can adjust later
    }));

    // Upsert (insert or update)
    const { error } = await supabase.from("players").upsert(formattedPlayers);

    if (error) {
      console.error("Error updating Supabase:", error);
    } else {
      console.log("✅ Successfully updated players in Supabase!");
    }
  } catch (err) {
    console.error("❌ Something went wrong:", err);
  }
}

updatePlayers();
