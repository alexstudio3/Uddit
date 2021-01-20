-- SQL queries
-- using checks 
-- use constraints
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS topics CASCADE;
DROP TABLE IF EXISTS posts CASCADE;
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS votes CASCADE;

-- Allow new users to register:
CREATE TABLE users (
  id SERIAL PRIMARY KEY, 
  username VARCHAR(25) UNIQUE NOT NULL,
  last_login TIMESTAMP
);

-- Allow registered users to create new topics:
CREATE TABLE topics (
  id SERIAL PRIMARY KEY, 
  name VARCHAR(30) UNIQUE,
  description VARCHAR(500),
  user_id INTEGER REFERENCES users 
);

-- Allow registered users to create new posts on existing topics:
CREATE TABLE posts (
  id SERIAL PRIMARY KEY, 
  title VARCHAR(100) NOT NULL,
  created_on TIMESTAMP,
  url VARCHAR(500), 
  text_content TEXT,
  topic_id INTEGER REFERENCES topics ON DELETE CASCADE,
  user_id INTEGER REFERENCES users ON DELETE SET NULL,
  CONSTRAINT control CHECK (
  url IS NOT NULL
  OR text_content IS NOT NULL
));

CREATE INDEX post_url ON posts(url);

-- Allow registered users to comment on existing posts:
CREATE TABLE comments (
    id SERIAL PRIMARY KEY, 
    text_content VARCHAR NOT NULL,
    parent_comment_id INT DEFAULT NULL,
    created_on TIMESTAMP,
    post_id INTEGER REFERENCES posts ON DELETE CASCADE,
    user_id INTEGER REFERENCES users ON DELETE SET NULL,
    CONSTRAINT oringal_thread FOREIGN KEY(parent_comment_id) REFERENCES comments(id) ON DELETE CASCADE
);

--  a given user can only vote once on a given post
CREATE TABLE votes (
  id SERIAL PRIMARY KEY, 
  vote INT CHECK(vote =1 OR vote = -1),
  post_id INTEGER REFERENCES posts ON DELETE CASCADE,
  user_id INTEGER REFERENCES users ON DELETE SET NULL,
  CONSTRAINT "one_vote_per_user" UNIQUE(user_id, post_id)
);

CREATE INDEX for_vote_score ON votes(post_id, vote)
