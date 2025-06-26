from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import json
import os

class ActionOpeningHours(Action):

    def name(self) -> Text:
        return "action_opening_hours"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        try:
            file_path = os.path.join(os.path.dirname(__file__), "opening_hours.json")
            with open(file_path, "r") as f:
                data = json.load(f)
                hours = data.get("opening_hours", "Brak danych o godzinach.")
        except Exception as e:
            hours = f"Błąd podczas wczytywania danych: {e}"

        dispatcher.utter_message(text=hours)
        return []
