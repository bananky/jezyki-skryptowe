from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
import json
import os
from rasa_sdk.events import SlotSet

class ActionTakeOrder(Action):
    def name(self) -> str:
        return "action_take_order"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: dict):

        dishes = [e.get("value") for e in tracker.latest_message.get("entities", [])
                  if e.get("entity") == "dish"]

        if not dishes:
            dispatcher.utter_message(text="Nie rozpoznałem żadnego dania z menu 😔")
            return []

        dispatcher.utter_message(text=f"✅ Zamówienie przyjęte: {', '.join(dishes)}. Podaj prosze adres dostawy.")
        return [SlotSet("ordered_items", dishes)]


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
        
class ActionMenu(Action):
    def name(self) -> str:
        return "action_menu"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: dict) -> list:

        filepath = os.path.join(os.path.dirname(__file__), "menu.json")

        try:
            with open(filepath, "r", encoding="utf-8") as f:
                data = json.load(f)
                menu_items = data.get("menu", [])
                menu_text = "\n".join(f"- {item}" for item in menu_items)
                dispatcher.utter_message(text=f"Oto dzisiejsze menu:\n{menu_text}")
        except Exception as e:
            dispatcher.utter_message(text="❌ Nie udało się załadować menu.")

        return []


class ActionSummarizeOrder(Action):
    def name(self) -> str:
        return "action_summarize_order"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: dict):

        items = tracker.get_slot("ordered_items")

        if not items:
            dispatcher.utter_message(text="Nie mam żadnych informacji o zamówieniu.")
        else:
            summary = "\n".join(f"- {item}" for item in items)
            dispatcher.utter_message(text=f"📦 Twoje zamówienie:\n{summary}")

        return []


class ActionConfirmAddress(Action):

    def name(self) -> Text:
        return "action_confirm_address"

    def run(self, dispatcher: CollectingDispatcher,
            tracker: Tracker,
            domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:

        address = tracker.latest_message.get("text")
        dispatcher.utter_message(text=f"Zamówienie zostanie dostarczone na adres: {address}.")
        return [SlotSet("delivery_address", address)]
