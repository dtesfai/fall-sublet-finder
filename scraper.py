import psycopg2
from urllib.request import urlopen
import lxml.html as website
from lxml.cssselect import CSSSelector

quote_page = "https://listings.och.uwaterloo.ca/Listings/Search/Results?re=0&rl=&ru=&aa=2&trm=1&occ=0&g=0&smk=0&cty=&str=&its=&v=&tt=&afm=9&afy=2019&atm=12&aty=2019&bt=&pt=0&pkm=&ps=30"
page = urlopen(quote_page)

doc = website.parse(page)

# finds number of apartments available (not currently used)
sel = CSSSelector("#mainContentSpan > div:nth-child(8)")
print(sel(doc)[0].text_content().split(" ")[0] + "\n")

try:
	connection = psycopg2.connect(user="",
	                              password="",
	                              host="",
	                              port="",
	                              database="")
	cursor = connection.cursor()

	# Compare addresses to those in database
	for num in range(1, 31):
		try:
			sel = CSSSelector("#Rentals > table > tbody > tr:nth-child(" + str(num) + ") > td:nth-child(2) > span > a")
			address = sel(doc)[0].text_content().strip();
			
			sel = CSSSelector("#Rentals > table > tbody > tr:nth-child(" + str(num) + ") > td.t-last")
			price = " ".join(sel(doc)[0].text_content().strip().split());
			
			query = "SELECT exists (SELECT 1 FROM apartments WHERE addr = %s LIMIT 1);"
			cursor.execute(query, (address, ))
			records = cursor.fetchall()[0][0]
			if records: continue

			# If a new address is found, write to db and send an email
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