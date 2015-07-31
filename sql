SELECT * FROM raif.raif_programs;
INSERT INTO raif_themes(theme_name,theme_title,theme_desc,created_date) VALUES('RobotzLand','RobotzLand','RobotzLand',now());
INSERT INTO raif_themes(theme_name,theme_title,theme_desc,created_date) VALUES('RobotzSpace','RobotzSpace','RobotzSpace',now());
INSERT INTO raif_themes(theme_name,theme_title,theme_desc,created_date) VALUES('MyInnovation','MyInnovation','MyInnovation',now());

INSERT INTO raif_categories(category_name,created_date) VALUES('The Foot Ball League',now());
INSERT INTO raif_categories(category_name,created_date) VALUES('The Gladiator',now());
INSERT INTO raif_categories(category_name,created_date) VALUES('The Servivor Pro',now());
INSERT INTO raif_categories(category_name,created_date) VALUES('The Mars Rover',now());
INSERT INTO raif_categories(category_name,created_date) VALUES('Glider Mania',now());
INSERT INTO raif_categories(category_name,created_date) VALUES('Yotta Events',now());

INSERT INTO raif_theme_categories(theme_id,category_id) VALUES(1,1);
INSERT INTO raif_theme_categories(theme_id,category_id) VALUES(1,2);
INSERT INTO raif_theme_categories(theme_id,category_id) VALUES(1,3);
INSERT INTO raif_theme_categories(theme_id,category_id) VALUES(2,4);
INSERT INTO raif_theme_categories(theme_id,category_id) VALUES(2,5);
INSERT INTO raif_theme_categories(theme_id,category_id) VALUES(3,6);
commit;


DELIMITER $$
CREATE FUNCTION fetch_all_themes() RETURNS VARCHAR(20000) 
BEGIN
	DECLARE v_theme_id INT(11);
	DECLARE v_theme_name VARCHAR(45);
	DECLARE v_theme_title VARCHAR(75);
	DECLARE v_theme_desc VARCHAR(250);
	DECLARE isfirst INT(2) DEFAULT 1;
	DECLARE isOuterFirst INT(2) DEFAULT 1;
	DECLARE themes_done INT(1) DEFAULT 0;
	DECLARE result VARCHAR(20000) DEFAULT "[";
	DECLARE themes_cur CURSOR FOR SELECT theme_id,IFNULL(theme_name,""),IFNULL(theme_title,""),IFNULL(theme_desc,"") FROM raif_themes;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET themes_done=1;
	OPEN themes_cur;
	themes_loop:LOOP
		FETCH themes_cur INTO v_theme_id,v_theme_name,v_theme_title,v_theme_desc;
		IF themes_done=1 THEN
			LEAVE themes_loop;
		END IF;
		IF isOuterFirst = 0 THEN
			SET result=CONCAT(result,",");
		END IF;
		SET isOuterFirst=0;
		SET result = CONCAT(result,"{\"theme_id\":\"",v_theme_id,"\",\"theme_name\":\"",v_theme_name,"\",\"theme_title\":\"",v_theme_title,"\",\"theme_desc\":\"",v_theme_desc,"\"");
		SET result=CONCAT(result,",\"categories\":[");
		SET isfirst=1;
		
		BLOCK2:BEGIN
			DECLARE v_cat_id INT(11);
			DECLARE v_cat_name VARCHAR(45);
			DECLARE v_cat_desc VARCHAR(250);
			DECLARE v_theme_cat_id INT(11);
			DECLARE cats_done INT(1) DEFAULT 0;		
			DECLARE category_cur CURSOR FOR SELECT raifcats.category_id,IFNULL(raifcats.category_name,""),IFNULL(raifcats.category_desc,"") 
											FROM raif_categories raifcats 
											INNER JOIN raif_theme_categories thcats ON raifcats.category_id=thcats.category_id 
											WHERE thcats.theme_id=v_theme_id;
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET cats_done=1;
			OPEN category_cur;
			cats_loop:LOOP
					FETCH category_cur INTO v_cat_id,v_cat_name,v_cat_desc;
					SELECT theme_category_id INTO v_theme_cat_id FROM raif_theme_categories WHERE theme_id=v_theme_id and category_id=v_cat_id;
					IF cats_done=1 THEN
						LEAVE cats_loop;
					END IF;
					IF isfirst=0 THEN 
						SET result=CONCAT(result,",");
					END IF;
					SET result =CONCAT(result,"{\"category_id\":\"",v_cat_id,"\",\"category_name\":\"",v_cat_name,"\",\"category_desc\":\"",v_cat_desc,"\",\"theme_cat_id\":\"",v_theme_cat_id,"\"}");
					SET isfirst=0;
			END LOOP;
			SET result=CONCAT(result,"]");
			CLOSE category_cur;
		END BLOCK2;		
		SET result=CONCAT(result,"}");	
	END LOOP;
	CLOSE themes_cur;	
	SET result=CONCAT(result,"]");
	RETURN result;
END $$
DROP FUNCTION fetch_all_themes;
SELECT fetch_all_themes();

DELIMITER $$
CREATE FUNCTION update_lead(p_team_id INT(11),p_lead_id INT(11)) RETURNS INT(11) 
BEGIN 
	UPDATE raif_teams SET team_lead_id=p_lead_id WHERE team_id=p_team_id;
	IF row_count()>0 THEN
		RETURN 1;
	ELSE
		RETURN 0;
	END IF;
END $$

DELIMITER $$
CREATE FUNCTION add_user(p_member_name VARCHAR(45),p_member_email_id VARCHAR(45),p_contact_no VARCHAR(45),p_is_lead INT(2),p_team_id INT(11)) RETURNS INT(11)
BEGIN
	DECLARE v_user_id INT(11);
	
	INSERT INTO raif_club_members(member_name,member_email_id,contact_no,created_date) VALUES(p_member_name,p_member_email_id,p_contact_no,now());
	SET v_user_id = LAST_INSERT_ID();
	IF p_is_lead = 1 THEN
		IF update_lead(p_team_id,v_user_id)=1 THEN 
			RETURN 1;
		ELSE
			RETURN -1;
		END IF;
	ELSE 
		IF v_user_id>0 THEN
			RETURN 1;
		ELSE
			RETURN -2;
		END IF;
	END IF;
	RETURN 0;
END $$


DELIMITER $$
CREATE FUNCTION get_teams(p_set_id INT(11)) RETURNS VARCHAR(20000)
BEGIN
	DECLARE v_team_id	INT(11);
	DECLARE v_team_name VARCHAR(45);
	DECLARE v_team_lead_id INT(11);
	DECLARE v_team_size INT(11);
	DECLARE v_activation_status VARCHAR(1);
	DECLARE v_theme_name VARCHAR(45);
	DECLARE v_cat_name VARCHAR(45);
	DECLARE v_created_date DATETIME;
	DECLARE teams_done INT(1) DEFAULT 0;		
	DECLARE teams_cur CURSOR FOR SELECT rt.team_id,rt.team_name,rt.team_lead_id ,rt.team_size,rt.activation_status,rth.theme_name,rc.category_name,rt.created_date
								  FROM raif_teams rt INNER JOIN raif_theme_categories rtc ON rt.theme_cat_id = rtc.theme_category_id
													 INNER JOIN raif_themes rth ON rtc.theme_id= rth.theme_id	
													 INNER JOIN raif_categories rc ON rtc.category_id = rc.category_id
								  WHERE rt.set_id = p_set_id; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET teams_done=1;
	OPEN teams_cur;
	teams_cur :LOOP
		FETCH teams_cur INTO $v_team_id,$v_team_name,$v_team_lead_id,$v_team_size,$v_activation_status,$v_theme_name,$v_cat_name,$v_created_date;
		BLOCK2:BEGIN
			DECLARE users_cur CURSOR FOR SELECT 
	
	
													 

END $$

SELECT rt.team_id,rt.team_name,rt.team_lead_id ,rt.team_size,rt.activation_status,rth.theme_name,rc.category_name,rt.created_date
								  FROM raif_teams rt INNER JOIN raif_theme_categories rtc ON rt.theme_cat_id = rtc.theme_category_id
													 INNER JOIN raif_themes rth ON rtc.theme_id= rth.theme_id	
													 INNER JOIN raif_categories rc ON rtc.category_id = rc.category_id
								  WHERE rt.set_id = 2; 
