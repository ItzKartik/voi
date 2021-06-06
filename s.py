u = "http://198.204.236.19:5827/external/server/Pay"
import requests
header = {
    "Content-Type":"application/json;charset=UTF-8",
    "User-Agent":"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Mobile Safari/537.36"
}

data = {
    "ownerName": "stripedemo",
    "ownerType": "44",
    "money": "100",
    "memo": "Stripe"
}

p = requests.post(url=u, headers=header, data=data)
print(p)
print(p.text)