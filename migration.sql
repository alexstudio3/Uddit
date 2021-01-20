INSERT INTO users(username)
	SELECT DISTINCT username
	FROM bad_posts
	UNION 
  SELECT DISTINCT username
  FROM bad_comments
  UNION 
  SELECT DISTINCT regexp_split_to_table(upvotes, ',')
  FROM bad_posts
  UNION 
  SELECT DISTINCT regexp_split_to_table(downvotes, ',')
  FROM bad_posts;
-- 11077

-- topics
INSERT INTO topics(name)
SELECT DISTINCT topic FROM bad_posts;
-- 89

-- posts
INSERT INTO posts(user_id, topic_id, title, url, text_content)
SELECT u.id, t.id, LEFT(title,100), bp.url, bp.text_content 
FROM bad_posts bp
JOIN users u 
ON u.username = bp.username
JOIN topics t 
ON t.name = bp.topic;
-- 50000

-- comments
INSERT INTO comments(user_id, post_id, text_content)
SELECT u.id, bc.post_id, bc.text_content
FROM bad_comments bc
JOIN posts p 
ON p.id = bc.post_id
JOIN users u 
ON p.user_id = u.id;
-- 100000
-- note, this needs to run after posts

-- votes

INSERT INTO votes(user_id, post_id, vote)
SELECT u.id, bp.id, 1 AS vote_tally
FROM (SELECT id, REGEXP_SPLIT_TO_TABLE(upvotes,',') AS upvote_users
FROM bad_posts) bp
JOIN users u ON u.username=bp.upvote_users;
-- 249799

INSERT INTO votes(user_id, post_id, vote)
SELECT u.id, bp.id, -1 AS vote_tally
FROM (SELECT id, REGEXP_SPLIT_TO_TABLE(downvotes,',') AS downvote_users 
FROM bad_posts) bp
JOIN users u ON u.username=bp.downvote_users;
-- 249911
