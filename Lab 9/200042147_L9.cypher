
// Create customer nodes
CREATE (:Customer {id: "1", name: "Tees", phone_no: "1234567890", age: 30, gender: "male", country: "USA"})
CREATE (:Customer {id: "2", name: "Zayed", phone_no: "0987654321", age: 40, gender: "male", country: "Gram"})
CREATE (:Customer {id: "3", name: "Lomatul", phone_no: "5555555555", age: 25, gender: "female", country: "Australia"})

// Create genre nodes
CREATE (:Genre {name: "Science Fiction"})
CREATE (:Genre {name: "Mystery"})
CREATE (:Genre {name: "Romance"})
CREATE (:Genre {name: "Thriller"})

// Create author nodes
CREATE (:Author {id: "a1", name: "Isaac Asimov", country: "USA", date_of_birth: "1920-01-02"})
CREATE (:Author {id: "a2", name: "Agatha Christie", country: "UK", date_of_birth: "1890-09-15"})
CREATE (:Author {id: "a3", name: "Jane Austen", country: "UK", date_of_birth: "1775-12-16"})

// Create book nodes
CREATE (:Book {id: "b1", title: "Foundation", published_year: 1951, language: "English", page_count: 255, price: 10.99})
CREATE (:Book {id: "b2", title: "Murder on the Orient Express", published_year: 1934, language: "English", page_count: 256, price: 9.99})
CREATE (:Book {id: "b3", title: "Pride and Prejudice", published_year: 1813, language: "English", page_count: 326, price: 12.99})

// Create relationships
MATCH (c:Customer {id: "1"}), (b:Book {id: "b1"})
CREATE (c)-[:PURCHASED {purchasing_date: "2022-01-01", amount: 10.99}]->(b)
MATCH (c:Customer {id: "2"}), (b:Book {id: "b2"})
CREATE (c)-[:PURCHASED {purchasing_date: "2022-02-14", amount: 9.99}]->(b)
MATCH (c:Customer {id: "3"}), (b:Book {id: "b3"})
CREATE (c)-[:PURCHASED {purchasing_date: "2022-03-31", amount: 12.99}]->(b)

MATCH (b:Book {id: "b1"}), (g:Genre {name: "Science Fiction"})
CREATE (b)-[:BELONGS_TO]->(g)
MATCH (b:Book {id: "b2"}), (g:Genre {name: "Mystery"})
CREATE (b)-[:BELONGS_TO]->(g)
MATCH (b:Book {id: "b3"}), (g:Genre {name: "Romance"})
CREATE (b)-[:BELONGS_TO]->(g)