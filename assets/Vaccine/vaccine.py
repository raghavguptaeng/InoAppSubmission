
import requests
import email
import smtplib
from datetime import date
import time
def is_ok(session):
    if(session["min_age_limit"] == 18 and session["vaccine"] == 'COVAXIN' and session['available_capacity_dose2'] > 2):
        return True;
while(True):
    try:
        print("Starting .......")
        url = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict"
        headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0"}
        arr = []
        info = []
        for i in range(142,151):
            params = {"district_id": str(i), "date": "31-05-2021"}
            resp = requests.get(url, params=params, headers=headers)
            data = resp.json()
            if(resp.status_code!=200):
                GPIO.output(14,GPIO.LOW)
                GPIO.output(15,GPIO.HIGH)
                print("Server Error")
                print("Will wait for 10 min")
                time.sleep(60)
                break;
            data = data['centers']
            for j in data:
                temp  = []
                for k in j['sessions']:
                    if(is_ok(k)):
                        temp.append(j['pincode'])
                        temp.append(j['name'])
                        temp.append(k['date'])
                        arr.append(temp)
        content = ''
        print(arr)
        for i in arr:
            content+=str(i[0])+'  '+str(i[1])+"  "+str(i[2]);
            content+='\n'
        print('\n\n')
        print(content)
        email_msg = email.message.EmailMessage()
        email_msg["Subject"] = "Vaccination Slot Open"
        email_msg["From"] = 'raghavgermany@gmail.com'
        email_msg["To"] = 'E19CSE258@bennett.edu.in'
        email_msg.set_content(content)
        print(email_msg)
        if(len(arr)!=0):
            with smtplib.SMTP(host='smtp.gmail.com', port='587') as server:
                server.starttls()
                server.login('Email ID', 'Password')
                server.send_message(email_msg, 'raghavgermany@gmail.com', 'e19cse258@bennett.edu.in')
        print("Hibernating")
        #time.sleep(10)
    except:
        print("Problem ..........")
        time.sleep(10)
