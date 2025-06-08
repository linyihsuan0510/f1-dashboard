import React, { useState } from "react";
import "./App.css";
import { MapContainer, TileLayer, Marker, Popup } from "react-leaflet";
import "leaflet/dist/leaflet.css";
import L from "leaflet";

// Leaflet marker fix for default icon (for local dev)
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon-2x.png",
  iconUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png",
});

const SEASONS = ["2023", "2024", "2025"];

const RACES = [
  { flag: "🇧🇭", name: "Bahrain Grand Prix", date: "2 MAR" },
  { flag: "🇸🇦", name: "Saudi Arabian Grand Prix", date: "9 MAR" },
  { flag: "🇦🇺", name: "Australian Grand Prix", date: "24 MAR" },
  { flag: "🇯🇵", name: "Japanese Grand Prix", date: "7 APR" },
  { flag: "🇨🇳", name: "Chinese Grand Prix", date: "21 APR" },
];

const CIRCUITS = [
  {
    id: "bahrain",
    name: "Bahrain International Circuit",
    location: "Sakhir",
    country: "Bahrain",
    lat: 26.0325,
    lng: 50.5106,
  },
  {
    id: "jeddah",
    name: "Jeddah Corniche Circuit",
    location: "Jeddah",
    country: "Saudi Arabia",
    lat: 21.6319,
    lng: 39.1044,
  },
  {
    id: "albert_park",
    name: "Albert Park Circuit",
    location: "Melbourne",
    country: "Australia",
    lat: -37.8497,
    lng: 144.968,
  },
  {
    id: "suzuka",
    name: "Suzuka International Racing Course",
    location: "Suzuka",
    country: "Japan",
    lat: 34.8431,
    lng: 136.541,
  },
  {
    id: "shanghai",
    name: "Shanghai International Circuit",
    location: "Shanghai",
    country: "China",
    lat: 31.3389,
    lng: 121.2216,
  },
];

export default function App() {
  const [season, setSeason] = useState(SEASONS[0]);
  const [view, setView] = useState("calendar");

  return (
    <div className="dashboard-container">
      <header>
        <h1>
          <span className="f1">FORMULA 1</span>
          <br />
          <span className="dashboard-title">Dashboard</span>
        </h1>
      </header>
      <div className="controls-row">
        <select
          className="season-select"
          value={season}
          onChange={(e) => setSeason(e.target.value)}
        >
          {SEASONS.map((s) => (
            <option key={s} value={s}>
              {s} Season
            </option>
          ))}
        </select>
        <div className="view-buttons">
          <button
            className={view === "calendar" ? "active" : ""}
            onClick={() => setView("calendar")}
          >
            Calendar
          </button>
          <button
            className={view === "map" ? "active" : ""}
            onClick={() => setView("map")}
          >
            Map
          </button>
        </div>
      </div>
      {view === "calendar" ? (
        <div className="race-list">
          {RACES.map((race) => (
            <div className="race-item" key={race.name}>
              <span className="race-flag">{race.flag}</span>
              <span className="race-name">{race.name}</span>
              <span className="race-date">{race.date}</span>
            </div>
          ))}
        </div>
      ) : (
        <div className="map-wrapper">
          <MapContainer
            center={[25, 40]}
            zoom={2}
            scrollWheelZoom={true}
            style={{ height: "420px", width: "100%", borderRadius: "12px" }}
          >
            <TileLayer
              attribution='&copy; OpenStreetMap contributors'
              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />
            {CIRCUITS.map((circuit) => (
              <Marker key={circuit.id} position={[circuit.lat, circuit.lng]}>
                <Popup>
                  <b>{circuit.name}</b>
                  <br />
                  {circuit.location}, {circuit.country}
                </Popup>
              </Marker>
            ))}
          </MapContainer>
        </div>
      )}
    </div>
  );
}