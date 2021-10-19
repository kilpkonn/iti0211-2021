import requests
import random
import time

from pyswip import Prolog

AIRPORTS = ["FRA", "ZRH", "BUE", "CHI", "LON", "MIL", "MOW", "NYC", "PAR", "ROM", "SAO", "STO", "TYO", "WAS", "LJU", "BTS", "SIN", "MAD", "PMI", "AGP", "ARN", "GOT", "BER", "BRE", "LUX"]

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
        res.append({"from": start, "to": end, "dep": dep, "arr": arr, "price": random.randint(10, 500)})
    return res

def add_data():
    trips = []
    for start in AIRPORTS:
        for end in AIRPORTS:
            if start == end:
                continue
            try:
                trip = query(start, end)
                print(trip)
                trips += trip
            except:
                print("Err:", start, end)
            time.sleep(1)

    trips = [f"lennukiga({t['from'].lower()}, {t['to'].lower()}, {t['price']}, time({t['dep'].replace(':', ', ')}, 0.0), time({t['arr'].replace(':', ', ')}, 0.0))\n" for t in trips]
    with open('data.pl', 'w') as f:
        f.writelines(trips)


def prolog_query(start, end):
    prolog = Prolog()
    prolog.consult("prax06.pl")
    trips = []
    with open("data.pl") as f:
        trips = f.readlines()
    for trip in trips:
        prolog.assertz(trip)
    # res = prolog.query(f"reisi({start}, {end}, Path, Cost, Time)")
    res = prolog.query(f"lyhim_reis({start}, {end}, Path, Cost)")
    # res = prolog.query(f"odavaim_reis({start}, {end}, Path, Cost)")  # <- change data file for it
    for sol in res:
        # print(sol["Path"], sol["Cost"], sol["Time"])
        print(sol["Path"], sol["Cost"])

if __name__ == "__main__":
    # add_data()
    prolog_query("fra", "arn")
    prolog_query("lon", "arn")
    prolog_query("fra", "pmi")
    prolog_query("got", "agp")
    prolog_query("mow", "sao")

