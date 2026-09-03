using System;
using System.IO;
using MelonLoader;
using BlackTheFall;

[assembly: MelonInfo(typeof(BlackTheFallAutosplitterMod.AutosplitterMod), "BlackTheFallAutosplitterMod", "1.0.0", "you")]
[assembly: MelonGame("Sand Sailor Studio", "BlackTheFall")]

namespace BlackTheFallAutosplitterMod
{
    public class AutosplitterMod : MelonMod
    {
        // File that LiveSplit's ASL script will read.
        // Sits right next to BlackTheFall.exe.
        private string _statePath;

        private string _lastLine = "";

        public override void OnApplicationStart()
        {
            _statePath = Path.Combine(MelonUtils.BaseDirectory, "autosplitter_state.txt");
            LoggerInstance.Msg("Autosplitter mod started. Writing state to: " + _statePath);
        }

        public override void OnUpdate()
        {
            try
            {
                // GameManager.Instance is null at the main menu / before a session starts.
                var gm = GameManager.Instance;

                string gameStage = "NONE";
                int zoneID = -1;
                int sceneID = -1;
                int checkpointSequence = -1;
                string checkpointName = "";
                bool isPaused = false;

                if (gm != null)
                {
                    gameStage = gm.GameStage.ToString();
                    isPaused = gm.IsPaused;

                    var cp = gm.CurrentCheckpoint;
                    if (cp != null)
                    {
                        checkpointSequence = cp.checkpointSequence;
                        checkpointName = cp.checkpointName;

                        if (cp.sceneManager != null)
                        {
                            zoneID = cp.sceneManager.zoneID;
                            sceneID = cp.sceneManager.sceneID;
                        }
                    }
                }

                // GameDirector.State - separate from GameManager, tracks MENU/LOADING/RUNNING/PAUSED
                string directorState = "NONE";
                if (GameDirector.Instance != null)
                {
                    directorState = GameDirector.State.ToString();
                }

                // Simple CSV line. Order matches what the ASL script expects.
                string line = string.Join(",", new string[]
                {
                    gameStage,
                    directorState,
                    zoneID.ToString(),
                    sceneID.ToString(),
                    checkpointSequence.ToString(),
                    isPaused.ToString(),
                    checkpointName
                });

                // Only write when something actually changed - keeps disk I/O light.
                if (line != _lastLine)
                {
                    File.WriteAllText(_statePath, line);
                    _lastLine = line;
                }
            }
            catch (Exception e)
            {
                LoggerInstance.Error("Autosplitter update error: " + e);
            }
        }
    }
}
