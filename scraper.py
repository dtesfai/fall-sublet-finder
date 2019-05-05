import psycopg2
import configparser
import inspect
import smtplib, ssl
from urllib.request import urlopen
import lxml.html as website
from lxml.cssselect import CSSSelector

quote_page = "https://listings.och.uwaterloo.ca/Listings/Search/Results?re=0&rl=&ru=&aa=2&trm=1&occ=0&g=0&smk=0&cty=&str=&its=&v=&tt=&afm=9&afy=2019&atm=12&aty=2019&bt=&pt=0&pkm=&ps=30"
page = urlopen(quote_page)

doc = website.parse(page)

# finds number of apartments available (not currently used)
sel = CSSSelector("#mainContentSpan > div:nth-child(8)")
print(sel(doc)[0].text_content().split(" ")[0] + "\n")

# read db credentials from config file
config = configparser.ConfigParser()
config.read("./credentials")
user = config.get("db_config", "user")
password = config.get("db_config", "password")

context = ssl.create_default_context()

try:
  connection = psycopg2.connect(user=user,
                                password=password,
                                host="localhost",
                                port="5432",
                                database="apartmentdb")
  cursor = connection.cursor()

  port = 465
  sender = config.get("email_config", "sender")
  reciever = config.get("email_config", "reciever")
  password = config.get("email_config", "password")

  server = smtplib.SMTP_SSL("smtp.gmail.com", port, context=context)
  server.login(sender, password)

  # Compare addresses to those in database
  for num in range(1, 31):
    try:
      sel = CSSSelector("#Rentals > table > tbody > tr:nth-child(" + str(num) + ") > td:nth-child(2) > span > a")
      address = sel(doc)[0].text_content().strip()
      url = "https://listings.och.uwaterloo.ca/" + sel(doc)[0].get("href")
      
      sel = CSSSelector("#Rentals > table > tbody > tr:nth-child(" + str(num) + ") > td.t-last")
      price = " ".join(sel(doc)[0].text_content().strip().split())

      query = "SELECT exists (SELECT 1 FROM apartments WHERE addr = %s LIMIT 1);"
      cursor.execute(query, (address, ))
      records = cursor.fetchall()[0][0]

      if records: continue

      # If a new address is found, write to db and send an email
      subject = "New apartment: {}".format(address)
      body = inspect.cleandoc("""Here's the details: 
                              Address: {}
                              Price: {}

                              Check it out at: {}.""".format(address, price, url))
      message = 'Subject: {}\n\n{}'.format(subject, body)

      server.sendmail(sender, reciever, message)

      query = "INSERT INTO apartments (addr, price) VALUES (%s, %s);"
      cursor.execute(query, (address, price))
    except:
      print("Iteration " + str(num) + " failed.")
      break

except (Exception, psycopg2.Error) as error:
    print ("Error while fetching data from PostgreSQL", error)
finally:
  if(connection):
    connection.commit()
    cursor.close()
    connection.close()
    print("PostgreSQL connection is closed")