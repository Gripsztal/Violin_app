
PRAGMA foreign_keys = ON;

CREATE TABLE exercise_types (
  id   INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE sessions (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  name         TEXT    NOT NULL,
  type_id      INTEGER NOT NULL REFERENCES exercise_types(id),
  duration_s   INTEGER NOT NULL CHECK (duration_s > 0),
  rating       INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  note         TEXT    NOT NULL DEFAULT '',
  practiced_at TEXT    NOT NULL DEFAULT (datetime('now','localtime'))
);
CREATE INDEX idx_sessions_date ON sessions(practiced_at);

CREATE TABLE intonation_samples (
  id         INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id INTEGER NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  t_ms       INTEGER NOT NULL,
  note       TEXT    NOT NULL,
  cents      REAL    NOT NULL CHECK (cents BETWEEN -50 AND 50)
);
CREATE INDEX idx_samples_session ON intonation_samples(session_id);

CREATE VIEW v_session_accuracy AS
SELECT s.id, s.name, s.practiced_at,
       ROUND(AVG(ABS(i.cents)), 1) AS avg_error_cents
FROM sessions s LEFT JOIN intonation_samples i ON i.session_id = s.id
GROUP BY s.id;

INSERT INTO exercise_types(id, name) VALUES (1,'Gama'), (2,'Etiuda'), (3,'Utwór');

INSERT INTO sessions(name, type_id, duration_s, rating, note, practiced_at) VALUES
 ('Kreutzer nr 2',        2, 1500, 4, 'Druga pozycja za nisko', datetime('now','localtime')),
 ('Gama G-dur',           1,  900, 5, '',                       datetime('now','localtime','-1 day')),
 ('Bach, Partita d-moll', 3, 2400, 3, 'Zwolnić tempo',          datetime('now','localtime','-2 days')),
 ('Gama A-dur, 3 oktawy', 1, 1200, 4, '',                       datetime('now','localtime','-4 days')),
 ('Mozart, Koncert nr 3', 3, 2100, 3, '',                       datetime('now','localtime','-5 days'));

