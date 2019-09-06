# Fall Sublet Finder

Finding a sublet for the Fall semester can be a difficult process. Given that there is a lot of competition, a slightly quicker message can give someone the advantage necessary to secure one. 

With the lack of API's available to track apartments, this process tends to be a manual one. Why not automate it?

This project scrapes, stores, and alerts end users of changes in the availablity of apartments on the University of Waterloo's [Off Campus Housing website](https://listings.och.uwaterloo.ca/Listings/Search/Results).

## Getting Started

In order to get this project up and running on your local machine, you will need to take 4 steps:

1. Restore the PostgreSQL database via the dump in the respository
2. Install the dependecies contained in requirements.txt
3. Insert the credentials to your PostgreSQL instance into scraper.py
4. Run `python3 scraper.py`
