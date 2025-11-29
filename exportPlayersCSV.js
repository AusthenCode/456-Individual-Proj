import fetch from "node-fetch";
import { createObjectCsvWriter } from "csv-writer";

const ALLOWED_POSITIONS = ["QB", "RB", "WR", "TE", "K"];
const CSV_FILE = "players.csv";

async function fetchPlayers() {
  console.log("⏳ Fetching NFL players from Sleeper...");
  
  const res = await fetch("https://api.sleeper.app/v1/players/nfl");
  const data = await res.json();

  // Filter for active players with correct positions
  const players = Object.values(data).filter(
    (p) =>
      ALLOWED_POSITIONS.includes((p.position || "").toUpperCase()) &&
      p.team &&
      p.active !== false
  );

  console.log(`📊 Found ${players.length} active players.`);
  return players.map((p, index) => ({
    id: p.player_id || index + 1,
    name: p.full_name || `${p.first_name || ""} ${p.last_name || ""}`.trim(),
    position: p.position,
    team: p.team,
    value: 0.0, // default value
  }));
}

async function exportCSV(players) {
  const csvWriter = createObjectCsvWriter({
    path: CSV_FILE,
    header: [
      { id: "id", title: "id" },
      { id: "name", title: "name" },
      { id: "position", title: "position" },
      { id: "team", title: "team" },
      { id: "value", title: "value" },
    ],
  });

  await csvWriter.writeRecords(players);
  console.log(`✅ CSV saved as ${CSV_FILE}`);
}

async function main() {
  const players = await fetchPlayers();
  await exportCSV(players);
}

main().catch(console.error);
