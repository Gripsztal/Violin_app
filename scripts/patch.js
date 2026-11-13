// Dodaje uprawnienie do mikrofonu do projektów Android i iOS (uruchamiane po "cap add").
const fs = require("fs");
const man = "android/app/src/main/AndroidManifest.xml";
if (fs.existsSync(man)) {
  let s = fs.readFileSync(man, "utf8");
  for (const p of ["RECORD_AUDIO", "MODIFY_AUDIO_SETTINGS"]) {
    if (!s.includes(p)) s = s.replace("</manifest>", `    <uses-permission android:name="android.permission.${p}" />\n</manifest>`);
  }
  fs.writeFileSync(man, s);
  console.log("Android: dodano uprawnienia mikrofonu");
}
const plist = "ios/App/App/Info.plist";
if (fs.existsSync(plist)) {
  let s = fs.readFileSync(plist, "utf8");
  if (!s.includes("NSMicrophoneUsageDescription")) {
    s = s.replace(/<\/dict>\s*<\/plist>/, "\t<key>NSMicrophoneUsageDescription</key>\n\t<string>Mikrofon służy do rozpoznawania wysokości dźwięku skrzypiec.</string>\n</dict>\n</plist>");
    fs.writeFileSync(plist, s);
  }
  console.log("iOS: dodano opis mikrofonu");
}
