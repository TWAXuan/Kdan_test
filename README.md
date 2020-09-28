# Response
## API Document (required)
  ---All the following get JSON---
### 1.List all book stores that are open at a certain datetime
API: */store_scan?type=datetime;date=<datetime>;time=<time>
1.date: YYYY-MM-DD
2.time: H:M

Ex: /store_scan?type=datetime;date=2020-09-15;time=13:20

Response:
```
[
  {
    "storeName": "Look Idgsgook"
  },
  {
    "storeName": "A Whole New World Bookstore"
  },
  {
    "storeName": "sdsdgds"
  },
  {
    "storeName": "Bookland"
  }
]

```
### 2. List all book stores that are open on a day of the week, at a certain time
API: */store_scan?type=weekdays;weekdays=<mon>
1.type: only weekdays
2.weekdays: only mon|tues|wed|thurs|fri|sat|sun

Ex: */store_scan?type=weekdays;weekdays=mon

Response:
```


[
  {
    "storeName": "Look Idgsgook"
  },
  {
    "storeName": "The Book Basement"
  },
  {
    "storeName": "A Whole New World Bookstore"
  },
  {
    "storeName": "Downtryyryoks"
  },
  {
    "storeName": "Uptown asaaooks"
  },
  {
    "storeName": "Turn the Page"
  },
  {
    "storeName": "sdsdgds"
  },
  {
    "storeName": "Undercover Books"
  },
  {
    "storeName": "Pick-a-Book"
  },
  {
    "storeName": "Bookland"
  }
]
```

### 3. List all book stores that are open for more or less than x hours per day or week
API: */store_scan?type=WeekOrDayOpening;range=<day>;hours=<4>;compare=<more>
range: day | week
hours:  Must be greater than zero
compare: more | less

Ex: */store_scan?type=WeekOrDay_Opening;range=day;hours=4;compare=more
Response:
```
[
  {
    "storeName": "The Book Basement"
  },
  {
    "storeName": "A Whole New World Bookstore"
  },
  {
    "storeName": "Downtryyryoks"
  },
  {
    "storeName": "Uptown asaaooks"
  },
  {
    "storeName": "Turn the Page"
  },
  {
    "storeName": "sdsdgds"
  },
  {
    "storeName": "Undercover Books"
  },
  {
    "storeName": "Bookland"
  }
]
```

### 4. List all books that are within a price range, sorted by price or alphabetically
API:  */books_scan?type=searchPrice;priceMin=<10>;priceMax=<100>;orderBy=<price>;sort=<lower>
priceMin、priceMin:  >0, can use double, priceMin < priceMax
orderBy: price | bookname
sort: rise | lower

Ex: */books_scan?type=searchPrice;priceMin=15;priceMax=50;orderBy=price;sort=lower
Response:
```
[
  {
    "bookName": "Building Restful Web Services With Go: Learn How To Build Powerful Restful Apis With Golang That Scale Gracefully",
    "price": "16.0"
  },
  {
    "bookName": "Swift",
    "price": "15.75"
  },
  {
    "bookName": "Devoted (elixir)",
    "price": "15.1"
  }
]
```

### 5. List all book stores that have more or less than x number of books within a price range
API: */store_scan?type=bookOwn;amount=<10>;compare="<less>

amount: should >= 1
compare: less | more

Ex: store_scan?type=bookOwn;amount=10;compare=less
Response:
```
[
  {
    "storeName": "Turn the Page",
    "amount": 9
  },
  {
    "storeName": "sdsdgds",
    "amount": 7
  },
  {
    "storeName": "Undercover Books",
    "amount": 5
  }
]
```

### 6. List all book stores that have more or less than x number of books within a price range
API: */store_scan?type=bookPriceAmount;priceMin=<5>;priceMax=<15>;compare=<more>;amount=<10>
priceMin, priceMax :  should > 0
compare : more | less
amount: Reference point

Ex: */store_scan?type=bookPriceAmount;priceMin=5;priceMax=15;compare=more;amount=10

Response:
```
[
  {
    "storeName": "Look Idgsgook",
    "amount": 14
  },
  {
    "storeName": "The Book Basement",
    "amount": 12
  },
  {
    "storeName": "A Whole New World Bookstore",
    "amount": 11
  },
  {
    "storeName": "Uptown asaaooks",
    "amount": 14
  },
  {
    "storeName": "Bookland",
    "amount": 12
  }
]
```

### 7. Search for book stores or books by name, ranked by relevance to search term
API: store_scan?type=searchName;targer=<book>;keyword=<sa>
targer: book | store  (search all by name)
keyword: any string

Ex: store_scan?type=searchName;targer=book;keyword=sa
Response:
```
[
  {
    "bookName": "Sandy Ruby"
  },
  {
    "bookName": "Sams Teach Yourself Go In 24 Hours: Next Generation Systems Programming With Golang: Next Generation Systems Programming With Golang"
  },
  {
    "bookName": "Rsafsahgdshdshsdhdshby In 24 Hours Or Less - A Beginner's Guide To Learning Ruby Programming Now (ruby, Ruby Programming, Ruby Course)"
  },
  {
    "bookName": "Elixir Saved (elixir Chronicles)"
  }
]
```

### 8. he top x users by total transaction amount within a date range
API: */store_scan?type=scenSeniorCustomer;dateMin=<2020-03-06>;dateMax=<2020-05-20>;limit=<5>
dateMin, dateMax: YYYY-MM-dd
limit: Top x users

Ex: store_scan?type=scenSeniorCustomer;dateMin=2020-03-06;dateMax=2020-05-20;limit=5
Response:
```
[
  {
    "top": 1,
    "userName": "Coy Mincks",
    "totalAmount": 78.5
  },
  {
    "top": 2,
    "userName": "Kasha Borda",
    "totalAmount": 25.08
  },
  {
    "top": 3,
    "userName": "Edith Johnson",
    "totalAmount": 24.9
  },
  {
    "top": 4,
    "userName": "Mark Gregoire",
    "totalAmount": 24.6
  },
  {
    "top": 5,
    "userName": "Phyllis Tennon",
    "totalAmount": 22.32
  }
]
```

### 9. The total number and dollar value of transactions that happened within a date range
API: store_scan?type=totalValueOfTransactions;dateMin=<2020-03-20>;dateMax=<2020-05-20>
dateMin, dateMax: YYYY-MM-dd

Ex: store_scan?type=totalValueOfTransactions;dateMin=2020-03-20;dateMax=2020-05-20
Response:
```
[
  {
    "transactionsCount": 20,
    "total": 233.62
  }
]
```

### 10. Edit book store name, book name, book price and user name

please into server index

### 11. The most popular book stores by transaction volume, either by number of transactions or transaction dollar value

API: */store_scan?type=topOfVolumn;targer=<amount>
targer: amount | count

Ex. */store_scan?type=topOfVolumn;targer=amount
Response:
```
[
  {
    "storeName": "Turn the Page"
  }
]
```


### 12. Total number of users who made transactions above or below $v within a date range
API: */store_scan?type=userTotalByPrice;dateMin=<2020-03-20>;dateMax=<2020-05-20>;compare=<more>;price=<10.3>

dateMin, dateMax: YYYY-MM-dd
compare: more | less
price: should >= 0

Response:
```
[
  {
    "total": 6
  }
]
```

### 13. Process a user purchasing a book from a book store, handling all relevant data changes in an atomic transaction

please into server index


## Import Data Commands
  `rake import_data:book_store["book_store_data"]`
  `rake import_data:user["user_data"]`
Original data is in /public dir

## Test Coverage Report(optional)
  check report [here](#test-coverage-reportoptional)
  
## Demo Site Url (optional)
  demo ready on [heroku](#demo-site-url-optional)