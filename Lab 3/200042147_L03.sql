SET SERVEROUTPUT ON SIZE 1000000

1--
create or replace Procedure 
find_required_time(title in varchar2)
As 
    time number;
    hour number;
    minute number;
    intermission number;
begin
    select max(mov_time) into time
    from movie
    where mov_title=title;

    hour:=0;
    minute:=0;
    intermission:=0;
    
    hour:=round(time/60);
    minute:=time-(hour*60);
    intermission:=round(time/70);
    intermission:=(intermission-1)*15;
    if(minute>30 and minute<70)then
        intermission:=intermission+15;
    end if;
    time:=time+intermission;
    hour:=round(time/60);
    minute:=time-(hour*60);
    DBMS_OUTPUT.PUT_LINE( 'HOUR:' || hour || 'Minute:' || minute);
end;
/

DECLARE
    movie varchar2(80);
begin
    movie :='&movie';
    find_required_time(movie);
end;
/

2--

create OR replace PROCEDURE find_toprated(n IN NUMBER) 
AS
Rows Number;
BEGIN
    Select count(*) into Rows
    from (SELECT COUNT(m.mov_id) 
    from movie m, rating r
    where m.mov_id = r.mov_id
    group by m.mov_title);

    if( n > Rows) then dbms_output.put_line('Error');
    else
        FOR i IN (select * from (SELECT mov_title, AVG(NVL(rev_stars, 0)) as average_rating
                  from movie m, rating r
                  where m.mov_id = r.mov_id
                  group by m.mov_title
                  order by average_rating DESC)
                  where ROWNUM <= n)

        LOOP    
            dbms_output.put_line(i.mov_title);
        END LOOP;
    End if;
END;
/   

DECLARE
    N number;
BEGIN
    N := '&N';
    find_toprated(N);
END ;
/

3--
create OR replace FUNCTION find_earning(id IN NUMBER)
RETURN NUMBER
AS
total_earning NUMBER;
num_review NUMBER;
release_date DATE;
current_date DATE;
mov_id NUMBER;
BEGIN
    SELECT COUNT(*) as num_review, m.mov_id
    INTO num_review, mov_id
    FROM rating r, movie m
    WHERE m.mov_id = r.mov_id AND r.mov_id = id AND r.rev_stars >= 6
    group by m.mov_id;

    SELECT m.mov_releasedate INTO release_date
    FROM movie m
    WHERE m.mov_id = id;

    current_date := SYSDATE;

    total_earning := num_review * 10;

    RETURN num_review/((current_date - release_date)/365);
END;
/


DECLARE
id number;
BEGIN
id :='&id';                                      
dbms_output.put_line(find_earning(id));
END;
/

4--
CREATE OR REPLACE FUNCTION find_genre_status(id IN NUMBER)
RETURN VARCHAR2
AS
    gen_title VARCHAR2(20);
    review_count NUMBER;
    avg_rating NUMBER(5,3);
    Genre_Status VARCHAR2(20);
    avg_review number(5,3);
    avg_rev_stars number(5,3);
BEGIN

    Select floor(Sum(total_review)/count(total_review)) INTO avg_review   
    from (SELECT g.GEN_TITLE, COUNT(r.REV_ID) as total_review
    FROM RATING r
    JOIN MTYPE mt ON r.MOV_ID = mt.MOV_ID
    JOIN GENRES g ON mt.GEN_ID = g.GEN_ID
    GROUP BY g.GEN_TITLE);

    SELECT AVG(NVL(REV_STARS, 0)) INTO avg_rev_stars FROM RATING;

    SELECT GEN_TITLE, COUNT(RATING.REV_ID), AVG(RATING.REV_STARS)
    INTO gen_title, review_count, avg_rating
    FROM GENRES, RATING, MTYPE 
    where GENRES.GEN_ID = MTYPE.GEN_ID 
        AND MTYPE.MOV_ID = RATING.MOV_ID  
        AND GENRES.GEN_ID = MTYPE.gen_id 
        AND id = GENRES.GEN_ID 
    GROUP BY GEN_TITLE;

    IF(review_count > avg_review) THEN 
        IF (avg_rating < avg_rev_stars) THEN Genre_Status := 'Widely Watched';
        ELSIF (avg_rating > avg_rev_stars) THEN Genre_Status := 'People''s Favorite';  
        END IF;
    
    ELSIF (review_count < avg_review  AND  avg_rating > avg_rev_stars) 
    THEN Genre_Status := 'Highly Rated';

    ELSE Genre_Status := 'So So';
    END IF; 

    RETURN 'Genre: ' || gen_title || '   Review_Count: ' || review_count ||
        '   Average_Rating: ' || avg_rating || '    Status: ' || Genre_Status;
END;
/

DECLARE
id number;
BEGIN
id:= '&id';
dbms_output.put_line(find_genre_status(id));
end;
/


5--
CREATE OR REPLACE FUNCTION find_most_frequent_genre (p_start_date DATE, p_end_date DATE)
RETURN VARCHAR2
AS
  genre VARCHAR2(20);
  count NUMBER;
BEGIN

    SELECT gen_title, genre_count INTO genre, count FROM
    (  
      SELECT g.gen_title, COUNT(*) as genre_count
      FROM movie m, mtype mt, genres g
      where  m.mov_id = mt.mov_id AND mt.gen_id = g.gen_id AND m.mov_releasedate 
      BETWEEN (p_start_date) AND (p_end_date)
      GROUP BY g.gen_title
      ORDER BY genre_count DESC
    )
    WHERE ROWNUM <= 1;

  RETURN 'The Genre: ' ||  genre || ' (' || count || ')';

END;
/

