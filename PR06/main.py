import requests
import random

AIRPORTS = ["FRA", "ZRH", "BUE", "CHI", "LON", "MIL", "MOW", "NYC", "PAR", "ROM", "SAO", "STO", "TYO", "WAS"]

def query(start, end) -> dict:
    url = f"https://api.lufthansa.com/v1/operations/schedules/{start}/{end}/2021-10-08?directFlights=0"
    resp = requests.get(url, headers = {
          "Accept": "application/json",
          "Authorization": "Bearer krwgupdn73au62264m8a6pag",
          "X-Originating-IP": "85.253.208.70"
        }).json()
    r = [b["Flight"] for b in resp["ScheduleResource"]["Schedule"]]
    res = []
    for a in r:
        if isinstance(a, list):
            continue
        dep = a["Departure"]["ScheduledTimeLocal"]["DateTime"].split("T")[1]
        arr = a["Arrival"]["ScheduledTimeLocal"]["DateTime"].split("T")[1]
        res.append({"from": start, "to": end, "departure": dep, "arrival": arr, "price": random.randint(10, 500)})
    return res

def add_data():
    for start in AIRPORTS:
        for end in AIRPORTS:
            if start == end:
                continue
            trip = query(start, end)
            print(trip)
            exit(0)


if __name__ == "__main__":
    add_data()    

