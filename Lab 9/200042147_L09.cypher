//Customer node
CREATE (:Customer {customer_id: "c1", name: "John Doe", phone_no: "1234567890", age: 30, gender: "Male", country: "USA"})
CREATE (:Customer {customer_id: "c2", name: "Tees", phone_no: "1234567891", age: 18, gender: "Male", country: "India"})
CREATE (:Customer {customer_id: "c3", name: "Nazmul", phone_no: "1234567892", age: 40, gender: "Female", country: "Canada"})
CREATE (:Customer {customer_id: "c4", name: "Dayan", phone_no: "1234567893", age: 9, gender: "Male", country: "France"})
CREATE (:Customer {customer_id: "c5", name: "Tahlil", phone_no: "1234567894", age: 56, gender: "Male", country: "Egypt"})

//Genre node
CREATE (:Genre {genre_id: "g1", name: "Fiction"})
CREATE (:Genre {genre_id: "g2", name: "Mystery"})
CREATE (:Genre {genre_id: "g3", name: "Novel"})
CREATE (:Genre {genre_id: "g4", name: "Poetry"})
CREATE (:Genre {genre_id: "g5", name: "Fantasy"})
CREATE (:Genre {genre_id: "g6", name: "Horror"})
CREATE (:Genre {genre_id: "g7", name: "Thriller"})

//Author node
CREATE (:Author {author_id: "a1", name: "Isaac Asimov", country: "USA", date_of_birth: "1920-01-02"})
CREATE (:Author {author_id: "a2", name: "Agatha Christie", country: "UK", date_of_birth: "1890-09-15"})
CREATE (:Author {author_id: "a3", name: "Jane Austen", country: "UK", date_of_birth: "1775-12-16"})
CREATE (:Author {author_id: "a4", name: "Stephen King", country: "USA", date_of_birth: "1947-9-21"})
CREATE (:Author {author_id: "a5", name: "Mark Twain", country: "USA", date_of_birth: "1835-11-9"})
CREATE (:Author {author_id: "a6", name: "J. K. Rowling", country: "UK", date_of_birth: "1965-7-31"})

//Book node
CREATE (:Book {book_id: "b1", title: "Pride and Prejudice", published_year: 1813, language: "English", page_count: 279, price: 10})
CREATE (:Book {book_id: "b2", title: "The body", published_year: 1993, language: "English", page_count: 300, price: 30})
CREATE (:Book {book_id: "b3", title: "The mist", published_year: 1913, language: "English", page_count: 179, price: 20})
CREATE (:Book {book_id: "b4", title: "Harry Potter", published_year: 2004, language: "English", page_count: 979, price: 90})
CREATE (:Book {book_id: "b5", title: "Harry Potter & the prisoner of Azkaban", published_year: 2006, language: "English", page_count: 779, price: 90})

//Relationships
//Customer purchases book
MATCH (c:Customer {customer_id: "c1"}), (b:Book {book_id: "b1"})
CREATE (c)-[:PURCHASED {purchasing_date: "2023-04-04", amount: 10}]->(b)
MATCH (c:Customer {customer_id: "c2"}), (b:Book {book_id: "b2"})
CREATE (c)-[:PURCHASED {purchasing_date: "2022-04-04", amount: 30}]->(b)
MATCH (c:Customer {customer_id: "c4"}), (b:Book {book_id: "b3"})
CREATE (c)-[:PURCHASED {purchasing_date: "2022-05-04", amount: 20}]->(b)
MATCH (c:Customer {customer_id: "c3"}), (b:Book {book_id: "b4"})
CREATE (c)-[:PURCHASED {purchasing_date: "2023-05-04", amount: 90}]->(b)
MATCH (c:Customer {customer_id: "c1"}), (b:Book {book_id: "b4"})
CREATE (c)-[:PURCHASED {purchasing_date: "2023-04-04", amount: 90}]->(b)

//Customer rates author
MATCH (c:Customer {customer_id: "c1"}), (a:Author {author_id: "a1"})
CREATE (c)-[:RATED {rating: 8}]->(a)
MATCH (c:Customer {customer_id: "c1"}), (a:Author {author_id: "a2"})
CREATE (c)-[:RATED {rating: 7}]->(a)
MATCH (c:Customer {customer_id: "c2"}), (a:Author {author_id: "a1"})
CREATE (c)-[:RATED {rating: 6}]->(a)

//Customer rates book
MATCH (c:Customer {customer_id: "c1"}), (b:Book {book_id: "b1"})
CREATE (c)-[:RATED {rating: 8}]->(b)
MATCH (c:Customer {customer_id: "c1"}), (b:Book {book_id: "b2"})
CREATE (c)-[:RATED {rating: 7}]->(b)

//Book has genre
MATCH (b:Book {book_id: "b1"}), (g:Genre {genre_id: "g1"})
CREATE (b)-[:BELONGS_TO]->(g)
MATCH (b:Book {book_id: "b2"}), (g:Genre {genre_id: "g1"})
CREATE (b)-[:BELONGS_TO]->(g)
MATCH (b:Book {book_id: "b3"}), (g:Genre {genre_id: "g3"})
CREATE (b)-[:BELONGS_TO]->(g)
MATCH (b:Book {book_id: "b4"}), (g:Genre {genre_id: "g4"})
CREATE (b)-[:BELONGS_TO]->(g)

//Book has volumes
MATCH (bo1:Book {book_id: "b4"}), (b02:Book {book_id: "b5"})
CREATE (b01)-[: Volume_of ]-> (b02)

//Author writes book
MATCH (a:Author {author_id: "a1"}), (b:Book {book_id: "b1"})
CREATE (a)-[:Writes {writing_year: 2006}]->(b)
MATCH (a:Author {author_id: "a2"}), (b:Book {book_id: "b2"})
CREATE (a)-[:Writes {writing_year: 1977}]->(b)
MATCH (a:Author {author_id: "a3"}), (b:Book {book_id: "b3"})
CREATE (a)-[:Writes {writing_year: 2001}]->(b)
MATCH (a:Author {author_id: "a4"}), (b:Book {book_id: "b4"})
CREATE (a)-[:Writes {writing_year: 1991}]->(b)

//a
MATCH (c:Customer)-[p:PURCHASED]->(b:Book)
RETURN b.title AS book_title, SUM(p.amount) AS total_revenue

//b
MATCH (c:Customer)-[r:RATED]->(b:Book)-[:BELONGS_TO]->(g:Genre)
RETURN g.name AS genre, AVG(r.rating) AS average_rating

//c
MATCH (c:Customer {name: 'John Doe'})-[p:PURCHASED]->(b:Book)
WHERE p.purchasing_date >= '2000-01-01' AND p.purchasing_date <= '2023-12-31'
RETURN b.title AS book_title, p.purchasing_date AS purchase_date

//d
MATCH (c:Customer)-[p:PURCHASED]->(b:Book)
WITH c, COUNT(b) AS num_books
ORDER BY num_books DESC LIMIT 1
RETURN c.name AS customer_name, num_books AS total_books_purchased

//e
MATCH (b:Book)<-[p:PURCHASED]-(c:Customer)
WITH b, COUNT(*) AS num_purchases
ORDER BY num_purchases DESC
RETURN b.title AS book_title, num_purchases AS total_purchases

//f


MATCH (c:Customer)-[pr:PURCHASED|RATED]->(b:Book)
WHERE b.title = 'Pride and Prejudice'
RETURN c.name, pr.rating, pr.purchasing_date

//g
MATCH (c:Customer)-[:PURCHASED]->(b:Book)<-[:WRITES]-(a:Author {name: 'Stephen King'})
RETURN c.name AS customer_name

//h
MATCH (b1:Book)<-[:PURCHASED]-(c:Customer)-[:PURCHASED]->(b2:Book)
WHERE b1 <> b2
WITH b1, b2, COUNT(*) AS freq
ORDER BY freq DESC
RETURN b1.title AS book1_title, b2.title AS book2_title, freq AS purchase_frequency

