-- generated by sqlalchemy

CREATE TABLE IF NOT EXISTS vod.`Basic_Category` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	name VARCHAR(128) NOT NULL, 
	parent_id BIGINT, 
	is_series SMALLINT, 
	is_collected SMALLINT, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Category_customer_id` ON vod.`Basic_Category` (customer_id);
CREATE INDEX `ix_Basic_Category_parent_id` ON vod.`Basic_Category` (parent_id);
CREATE INDEX `ix_Basic_Category_deleted` ON vod.`Basic_Category` (deleted);
CREATE INDEX `ix_Basic_Category_modified_time` ON vod.`Basic_Category` (modified_time);
CREATE TABLE IF NOT EXISTS vod.frontpage_strategy (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	date INTEGER NOT NULL, 
	tiles VARCHAR(4096), 
	layout INTEGER NOT NULL, 
	convert_date VARCHAR(64), 
	front_name VARCHAR(50), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_frontpage_strategy_deleted ON vod.frontpage_strategy (deleted);
CREATE INDEX ix_frontpage_strategy_modified_time ON vod.frontpage_strategy (modified_time);
CREATE INDEX ix_frontpage_strategy_date ON vod.frontpage_strategy (date);
CREATE INDEX ix_frontpage_strategy_customer_id ON vod.frontpage_strategy (customer_id);
CREATE TABLE IF NOT EXISTS vod.`Basic_Media` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	title VARCHAR(250) NOT NULL, 
	escape_title VARCHAR(250) NOT NULL, 
	origin_name VARCHAR(256), 
	tag VARCHAR(1024), 
	aka VARCHAR(512), 
	summary TEXT, 
	definition VARCHAR(128), 
	pubdate DATETIME, 
	rate FLOAT, 
	is_clip SMALLINT, 
	is_3d SMALLINT, 
	next_update_time VARCHAR(256), 
	available SMALLINT NOT NULL, 
	online SMALLINT NOT NULL, 
	season_id SMALLINT, 
	total SMALLINT, 
	total_season SMALLINT, 
	current INTEGER, 
	country VARCHAR(256), 
	language VARCHAR(512), 
	updatefrq VARCHAR(128), 
	image_post_url VARCHAR(1024), 
	image_icon_url VARCHAR(1024), 
	image_rec_url VARCHAR(1024), 
	default_play_source BIGINT, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Media_deleted` ON vod.`Basic_Media` (deleted);
CREATE INDEX `ix_Basic_Media_escape_title` ON vod.`Basic_Media` (escape_title);
CREATE INDEX `ix_Basic_Media_modified_time` ON vod.`Basic_Media` (modified_time);
CREATE INDEX `ix_Basic_Media_title` ON vod.`Basic_Media` (title);
CREATE INDEX `ix_Basic_Media_customer_id` ON vod.`Basic_Media` (customer_id);
CREATE TABLE IF NOT EXISTS vod.category_frontpage_strategy (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	navigation_id INTEGER, 
	strategy_id INTEGER, 
	date INTEGER NOT NULL, 
	name VARCHAR(256), 
	tiles VARCHAR(4096), 
	layout INTEGER NOT NULL, 
	convert_date VARCHAR(64), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_category_frontpage_strategy_modified_time ON vod.category_frontpage_strategy (modified_time);
CREATE INDEX ix_category_frontpage_strategy_customer_id ON vod.category_frontpage_strategy (customer_id);
CREATE INDEX ix_category_frontpage_strategy_date ON vod.category_frontpage_strategy (date);
CREATE INDEX ix_category_frontpage_strategy_navigation_id ON vod.category_frontpage_strategy (navigation_id);
CREATE INDEX ix_category_frontpage_strategy_deleted ON vod.category_frontpage_strategy (deleted);
CREATE INDEX ix_category_frontpage_strategy_strategy_id ON vod.category_frontpage_strategy (strategy_id);
CREATE TABLE IF NOT EXISTS vod.video_startup (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	provider_id INTEGER, 
	startup_type VARCHAR(512), 
	params VARCHAR(1024), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_video_startup_customer_id ON vod.video_startup (customer_id);
CREATE INDEX ix_video_startup_deleted ON vod.video_startup (deleted);
CREATE INDEX ix_video_startup_modified_time ON vod.video_startup (modified_time);
CREATE TABLE IF NOT EXISTS vod.`Basic_Video` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	media_id BIGINT NOT NULL, 
	title VARCHAR(256) NOT NULL, 
	escape_title VARCHAR(256) NOT NULL, 
	series INTEGER, 
	summary TEXT, 
	pubdate VARCHAR(64), 
	time_length INTEGER, 
	available SMALLINT NOT NULL, 
	online SMALLINT NOT NULL, 
	image_post_url VARCHAR(1024), 
	image_icon_url VARCHAR(1024), 
	image_rec_url VARCHAR(1024), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Video_modified_time` ON vod.`Basic_Video` (modified_time);
CREATE INDEX `ix_Basic_Video_series` ON vod.`Basic_Video` (series);
CREATE INDEX `ix_Basic_Video_customer_id` ON vod.`Basic_Video` (customer_id);
CREATE INDEX `ix_Basic_Video_deleted` ON vod.`Basic_Video` (deleted);
CREATE INDEX `ix_Basic_Video_media_id` ON vod.`Basic_Video` (media_id);
CREATE TABLE IF NOT EXISTS vod.category_aggregation (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	aggregation_id INTEGER, 
	name VARCHAR(128) NOT NULL, 
	field_name VARCHAR(128), 
	categories VARCHAR(1000), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_category_aggregation_customer_id ON vod.category_aggregation (customer_id);
CREATE INDEX ix_category_aggregation_aggregation_id ON vod.category_aggregation (aggregation_id);
CREATE INDEX ix_category_aggregation_deleted ON vod.category_aggregation (deleted);
CREATE INDEX ix_category_aggregation_modified_time ON vod.category_aggregation (modified_time);
CREATE TABLE IF NOT EXISTS vod.vender_attr_mapping (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	vender_id BIGINT NOT NULL, 
	type VARCHAR(100) NOT NULL, 
	self_attr_value VARCHAR(256), 
	mapping_attr_value VARCHAR(256), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_vender_attr_mapping_modified_time ON vod.vender_attr_mapping (modified_time);
CREATE INDEX ix_vender_attr_mapping_type ON vod.vender_attr_mapping (type);
CREATE INDEX ix_vender_attr_mapping_customer_id ON vod.vender_attr_mapping (customer_id);
CREATE INDEX ix_vender_attr_mapping_deleted ON vod.vender_attr_mapping (deleted);
CREATE INDEX ix_vender_attr_mapping_vender_id ON vod.vender_attr_mapping (vender_id);
CREATE TABLE IF NOT EXISTS vod.monitor_data (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	monitor_type VARCHAR(128) NOT NULL, 
	total INTEGER NOT NULL, 
	total_success INTEGER NOT NULL, 
	total_fail INTEGER NOT NULL, 
	success_rate FLOAT NOT NULL, 
	longest_time INTEGER NOT NULL, 
	average_time INTEGER NOT NULL, 
	success_average_time INTEGER NOT NULL, 
	fail_average_time INTEGER NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_monitor_data_modified_time ON vod.monitor_data (modified_time);
CREATE INDEX ix_monitor_data_customer_id ON vod.monitor_data (customer_id);
CREATE INDEX ix_monitor_data_deleted ON vod.monitor_data (deleted);
CREATE TABLE IF NOT EXISTS vod.media_collections (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	collect_id BIGINT NOT NULL, 
	medias1 VARCHAR(2048), 
	medias2 VARCHAR(2048), 
	medias3 VARCHAR(2048), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_media_collections_customer_id ON vod.media_collections (customer_id);
CREATE INDEX ix_media_collections_collect_id ON vod.media_collections (collect_id);
CREATE INDEX ix_media_collections_deleted ON vod.media_collections (deleted);
CREATE INDEX ix_media_collections_modified_time ON vod.media_collections (modified_time);
CREATE TABLE IF NOT EXISTS vod.`userDevice` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	type VARCHAR(64) NOT NULL, 
	code VARCHAR(255) NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_userDevice_code` ON vod.`userDevice` (code);
CREATE INDEX `ix_userDevice_modified_time` ON vod.`userDevice` (modified_time);
CREATE INDEX `ix_userDevice_deleted` ON vod.`userDevice` (deleted);
CREATE INDEX `ix_userDevice_type` ON vod.`userDevice` (type);
CREATE INDEX `ix_userDevice_customer_id` ON vod.`userDevice` (customer_id);
CREATE TABLE IF NOT EXISTS vod.`Basic_UserHistory` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	user_id BIGINT NOT NULL, 
	media_id BIGINT NOT NULL, 
	video_id BIGINT NOT NULL, 
	view_duration BIGINT NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_UserHistory_user_id` ON vod.`Basic_UserHistory` (user_id);
CREATE INDEX `ix_Basic_UserHistory_modified_time` ON vod.`Basic_UserHistory` (modified_time);
CREATE INDEX `ix_Basic_UserHistory_customer_id` ON vod.`Basic_UserHistory` (customer_id);
CREATE INDEX `ix_Basic_UserHistory_media_id` ON vod.`Basic_UserHistory` (media_id);
CREATE INDEX `ix_Basic_UserHistory_deleted` ON vod.`Basic_UserHistory` (deleted);
CREATE TABLE IF NOT EXISTS vod.category_manager (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	category_id INTEGER, 
	name VARCHAR(128) NOT NULL, 
	category_info VARCHAR(1024), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_category_manager_modified_time ON vod.category_manager (modified_time);
CREATE INDEX ix_category_manager_customer_id ON vod.category_manager (customer_id);
CREATE INDEX ix_category_manager_category_id ON vod.category_manager (category_id);
CREATE INDEX ix_category_manager_name ON vod.category_manager (name);
CREATE INDEX ix_category_manager_deleted ON vod.category_manager (deleted);
CREATE TABLE IF NOT EXISTS vod.resource (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	url VARCHAR(256) NOT NULL, 
	type INTEGER NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_resource_customer_id ON vod.resource (customer_id);
CREATE INDEX ix_resource_deleted ON vod.resource (deleted);
CREATE INDEX ix_resource_modified_time ON vod.resource (modified_time);
CREATE TABLE IF NOT EXISTS vod.`Basic_Media_Entertainer_Rel` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	media_id BIGINT NOT NULL, 
	entertainer_id BIGINT NOT NULL, 
	type SMALLINT NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Media_Entertainer_Rel_customer_id` ON vod.`Basic_Media_Entertainer_Rel` (customer_id);
CREATE INDEX `ix_Basic_Media_Entertainer_Rel_media_id` ON vod.`Basic_Media_Entertainer_Rel` (media_id);
CREATE INDEX `ix_Basic_Media_Entertainer_Rel_deleted` ON vod.`Basic_Media_Entertainer_Rel` (deleted);
CREATE INDEX `ix_Basic_Media_Entertainer_Rel_modified_time` ON vod.`Basic_Media_Entertainer_Rel` (modified_time);
CREATE INDEX `ix_Basic_Media_Entertainer_Rel_entertainer_id` ON vod.`Basic_Media_Entertainer_Rel` (entertainer_id);
CREATE TABLE IF NOT EXISTS vod.`Basic_UserSettings` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	user_id BIGINT NOT NULL, 
	type VARCHAR(2), 
	item VARCHAR(128) NOT NULL, 
	value VARCHAR(256) NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_UserSettings_user_id` ON vod.`Basic_UserSettings` (user_id);
CREATE INDEX `ix_Basic_UserSettings_modified_time` ON vod.`Basic_UserSettings` (modified_time);
CREATE INDEX `ix_Basic_UserSettings_customer_id` ON vod.`Basic_UserSettings` (customer_id);
CREATE INDEX `ix_Basic_UserSettings_deleted` ON vod.`Basic_UserSettings` (deleted);
CREATE TABLE IF NOT EXISTS vod.`Basic_Vender` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	name VARCHAR(128) NOT NULL, 
	code VARCHAR(128), 
	level SMALLINT NOT NULL, 
	video_play_method VARCHAR(128), 
	video_play_package VARCHAR(128), 
	video_play_param VARCHAR(512), 
	pic_link VARCHAR(1024), 
	application_package VARCHAR(512), 
	status INTEGER NOT NULL, 
	online SMALLINT NOT NULL, 
	o_application_packages VARCHAR(1024), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Vender_customer_id` ON vod.`Basic_Vender` (customer_id);
CREATE INDEX `ix_Basic_Vender_deleted` ON vod.`Basic_Vender` (deleted);
CREATE INDEX `ix_Basic_Vender_modified_time` ON vod.`Basic_Vender` (modified_time);
CREATE TABLE IF NOT EXISTS vod.vodupgrade (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	`packageUrl` VARCHAR(256) NOT NULL, 
	`fromVersion` VARCHAR(64) NOT NULL, 
	`toVersion` VARCHAR(64) NOT NULL, 
	message VARCHAR(512) NOT NULL, 
	`packageName` VARCHAR(256) NOT NULL, 
	`fileSize` INTEGER NOT NULL, 
	`toVersion_name` VARCHAR(20) NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_vodupgrade_modified_time ON vod.vodupgrade (modified_time);
CREATE INDEX ix_vodupgrade_customer_id ON vod.vodupgrade (customer_id);
CREATE INDEX ix_vodupgrade_deleted ON vod.vodupgrade (deleted);
CREATE TABLE IF NOT EXISTS vod.oss_preview (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	mac VARCHAR(256), 
	date INTEGER NOT NULL, 
	convert_date VARCHAR(64), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_oss_preview_deleted ON vod.oss_preview (deleted);
CREATE INDEX ix_oss_preview_date ON vod.oss_preview (date);
CREATE INDEX ix_oss_preview_modified_time ON vod.oss_preview (modified_time);
CREATE INDEX ix_oss_preview_mac ON vod.oss_preview (mac);
CREATE INDEX ix_oss_preview_customer_id ON vod.oss_preview (customer_id);
CREATE TABLE IF NOT EXISTS vod.topic_category (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	strategy_id INTEGER, 
	type_name VARCHAR(256), 
	pic_link VARCHAR(1024), 
	online INTEGER, 
	summary VARCHAR(1024), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_topic_category_customer_id ON vod.topic_category (customer_id);
CREATE INDEX ix_topic_category_strategy_id ON vod.topic_category (strategy_id);
CREATE INDEX ix_topic_category_deleted ON vod.topic_category (deleted);
CREATE INDEX ix_topic_category_modified_time ON vod.topic_category (modified_time);
CREATE TABLE IF NOT EXISTS vod.area_apps (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	app_name VARCHAR(128) NOT NULL, 
	package_name VARCHAR(1024) NOT NULL, 
	pic_url VARCHAR(1024) NOT NULL, 
	media_type INTEGER NOT NULL, 
	height INTEGER NOT NULL, 
	width INTEGER NOT NULL, 
	xpos INTEGER NOT NULL, 
	ypos INTEGER NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_area_apps_customer_id ON vod.area_apps (customer_id);
CREATE INDEX ix_area_apps_deleted ON vod.area_apps (deleted);
CREATE INDEX ix_area_apps_modified_time ON vod.area_apps (modified_time);
CREATE TABLE IF NOT EXISTS vod.user_center_layout (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	title VARCHAR(200) NOT NULL, 
	icon_url VARCHAR(512) NOT NULL, 
	media_type INTEGER NOT NULL, 
	collect_type INTEGER NOT NULL, 
	width INTEGER NOT NULL, 
	height INTEGER NOT NULL, 
	xpos INTEGER NOT NULL, 
	ypos INTEGER NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_user_center_layout_modified_time ON vod.user_center_layout (modified_time);
CREATE INDEX ix_user_center_layout_customer_id ON vod.user_center_layout (customer_id);
CREATE INDEX ix_user_center_layout_deleted ON vod.user_center_layout (deleted);
CREATE TABLE IF NOT EXISTS vod.medias_update_record (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	title VARCHAR(250), 
	category_name VARCHAR(256), 
	child_category_name VARCHAR(1024), 
	media_id BIGINT NOT NULL, 
	actor_name VARCHAR(256), 
	director_name VARCHAR(256), 
	rate FLOAT, 
	play_times BIGINT, 
	vender VARCHAR(250), 
	vender_status VARCHAR(250), 
	definition VARCHAR(128), 
	total SMALLINT, 
	current INTEGER, 
	pubdate VARCHAR(64), 
	time_length VARCHAR(64), 
	online VARCHAR(64), 
	country VARCHAR(256), 
	summary TEXT, 
	image_icon_url VARCHAR(1024), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_medias_update_record_customer_id ON vod.medias_update_record (customer_id);
CREATE INDEX ix_medias_update_record_deleted ON vod.medias_update_record (deleted);
CREATE INDEX ix_medias_update_record_media_id ON vod.medias_update_record (media_id);
CREATE INDEX ix_medias_update_record_modified_time ON vod.medias_update_record (modified_time);
CREATE TABLE IF NOT EXISTS vod.batch_audit_media (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	taskid INTEGER NOT NULL, 
	file_path VARCHAR(1024), 
	description VARCHAR(1024), 
	title VARCHAR(250), 
	status VARCHAR(1024), 
	complete_time INTEGER, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_batch_audit_media_modified_time ON vod.batch_audit_media (modified_time);
CREATE INDEX ix_batch_audit_media_complete_time ON vod.batch_audit_media (complete_time);
CREATE INDEX ix_batch_audit_media_customer_id ON vod.batch_audit_media (customer_id);
CREATE INDEX ix_batch_audit_media_deleted ON vod.batch_audit_media (deleted);
CREATE INDEX ix_batch_audit_media_taskid ON vod.batch_audit_media (taskid);
CREATE TABLE IF NOT EXISTS vod.`Basic_Video_Entertainer_Rel` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	video_id BIGINT NOT NULL, 
	entertainer_id BIGINT NOT NULL, 
	type SMALLINT NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Video_Entertainer_Rel_deleted` ON vod.`Basic_Video_Entertainer_Rel` (deleted);
CREATE INDEX `ix_Basic_Video_Entertainer_Rel_video_id` ON vod.`Basic_Video_Entertainer_Rel` (video_id);
CREATE INDEX `ix_Basic_Video_Entertainer_Rel_modified_time` ON vod.`Basic_Video_Entertainer_Rel` (modified_time);
CREATE INDEX `ix_Basic_Video_Entertainer_Rel_entertainer_id` ON vod.`Basic_Video_Entertainer_Rel` (entertainer_id);
CREATE INDEX `ix_Basic_Video_Entertainer_Rel_customer_id` ON vod.`Basic_Video_Entertainer_Rel` (customer_id);
CREATE TABLE IF NOT EXISTS vod.`Basic_Entertainer` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	country VARCHAR(128), 
	origin_name VARCHAR(128), 
	stagename VARCHAR(128) NOT NULL, 
	aka VARCHAR(512), 
	birthday VARCHAR(64), 
	biography TEXT, 
	gender SMALLINT, 
	career VARCHAR(512), 
	works TEXT, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Entertainer_deleted` ON vod.`Basic_Entertainer` (deleted);
CREATE INDEX `ix_Basic_Entertainer_modified_time` ON vod.`Basic_Entertainer` (modified_time);
CREATE INDEX `ix_Basic_Entertainer_stagename` ON vod.`Basic_Entertainer` (stagename);
CREATE INDEX `ix_Basic_Entertainer_customer_id` ON vod.`Basic_Entertainer` (customer_id);
CREATE TABLE IF NOT EXISTS vod.`Basic_UserCollect` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	user_id VARCHAR(128) NOT NULL, 
	media_id BIGINT NOT NULL, 
	type SMALLINT NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_UserCollect_customer_id` ON vod.`Basic_UserCollect` (customer_id);
CREATE INDEX `ix_Basic_UserCollect_media_id` ON vod.`Basic_UserCollect` (media_id);
CREATE INDEX `ix_Basic_UserCollect_deleted` ON vod.`Basic_UserCollect` (deleted);
CREATE INDEX `ix_Basic_UserCollect_user_id` ON vod.`Basic_UserCollect` (user_id);
CREATE INDEX `ix_Basic_UserCollect_modified_time` ON vod.`Basic_UserCollect` (modified_time);
CREATE TABLE IF NOT EXISTS vod.new7days (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	category_type VARCHAR(256), 
	category_type2 VARCHAR(256), 
	type_code INTEGER, 
	all_name VARCHAR(256), 
	other_name VARCHAR(256), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_new7days_type_code ON vod.new7days (type_code);
CREATE INDEX ix_new7days_deleted ON vod.new7days (deleted);
CREATE INDEX ix_new7days_modified_time ON vod.new7days (modified_time);
CREATE INDEX ix_new7days_customer_id ON vod.new7days (customer_id);
CREATE TABLE IF NOT EXISTS vod.oss_user (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	name VARCHAR(200) NOT NULL, 
	role INTEGER NOT NULL, 
	status INTEGER NOT NULL, 
	scope VARCHAR(1024), 
	convert_scope BIGINT, 
	`staffId` BIGINT, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_oss_user_customer_id ON vod.oss_user (customer_id);
CREATE INDEX `ix_oss_user_staffId` ON vod.oss_user (`staffId`);
CREATE INDEX ix_oss_user_deleted ON vod.oss_user (deleted);
CREATE INDEX ix_oss_user_modified_time ON vod.oss_user (modified_time);
CREATE TABLE IF NOT EXISTS vod.cpsection (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	device_id VARCHAR(128) NOT NULL, 
	is_cpsection_activated INTEGER NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_cpsection_modified_time ON vod.cpsection (modified_time);
CREATE INDEX ix_cpsection_customer_id ON vod.cpsection (customer_id);
CREATE INDEX ix_cpsection_device_id ON vod.cpsection (device_id);
CREATE INDEX ix_cpsection_deleted ON vod.cpsection (deleted);
CREATE TABLE IF NOT EXISTS vod.`userLogin` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	`loginType` VARCHAR(16) NOT NULL, 
	`userId` INTEGER NOT NULL, 
	`loginInfo` VARCHAR(256) NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_userLogin_modified_time` ON vod.`userLogin` (modified_time);
CREATE INDEX `ix_userLogin_customer_id` ON vod.`userLogin` (customer_id);
CREATE INDEX `ix_userLogin_deleted` ON vod.`userLogin` (deleted);
CREATE TABLE IF NOT EXISTS vod.frontpage_layout (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	layout_index INTEGER NOT NULL, 
	layout_info VARCHAR(1024), 
	params VARCHAR(256), 
	image VARCHAR(512), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_frontpage_layout_modified_time ON vod.frontpage_layout (modified_time);
CREATE INDEX ix_frontpage_layout_customer_id ON vod.frontpage_layout (customer_id);
CREATE INDEX ix_frontpage_layout_deleted ON vod.frontpage_layout (deleted);
CREATE INDEX ix_frontpage_layout_layout_index ON vod.frontpage_layout (layout_index);
CREATE TABLE IF NOT EXISTS vod.`Basic_Media_Category_Rel` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	media_id BIGINT NOT NULL, 
	category_id BIGINT NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Media_Category_Rel_modified_time` ON vod.`Basic_Media_Category_Rel` (modified_time);
CREATE INDEX `ix_Basic_Media_Category_Rel_category_id` ON vod.`Basic_Media_Category_Rel` (category_id);
CREATE INDEX `ix_Basic_Media_Category_Rel_customer_id` ON vod.`Basic_Media_Category_Rel` (customer_id);
CREATE INDEX `ix_Basic_Media_Category_Rel_deleted` ON vod.`Basic_Media_Category_Rel` (deleted);
CREATE INDEX `ix_Basic_Media_Category_Rel_media_id` ON vod.`Basic_Media_Category_Rel` (media_id);
CREATE TABLE IF NOT EXISTS vod.startup_bg (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	startup_url VARCHAR(1024), 
	bg_url VARCHAR(1024), 
	vision_startup_url VARCHAR(1024), 
	vision_bg_url VARCHAR(1024), 
	date INTEGER NOT NULL, 
	convert_date VARCHAR(64), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_startup_bg_deleted ON vod.startup_bg (deleted);
CREATE INDEX ix_startup_bg_modified_time ON vod.startup_bg (modified_time);
CREATE INDEX ix_startup_bg_date ON vod.startup_bg (date);
CREATE INDEX ix_startup_bg_customer_id ON vod.startup_bg (customer_id);
CREATE TABLE IF NOT EXISTS vod.category_navigation (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	navigation_id INTEGER, 
	name VARCHAR(128) NOT NULL, 
	sequence INTEGER, 
	online INTEGER, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_category_navigation_modified_time ON vod.category_navigation (modified_time);
CREATE INDEX ix_category_navigation_customer_id ON vod.category_navigation (customer_id);
CREATE INDEX ix_category_navigation_deleted ON vod.category_navigation (deleted);
CREATE INDEX ix_category_navigation_navigation_id ON vod.category_navigation (navigation_id);
CREATE TABLE IF NOT EXISTS vod.topic_info (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	strategy_id INTEGER, 
	pic_link VARCHAR(1024), 
	music_link VARCHAR(1024), 
	medias VARCHAR(10240), 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX ix_topic_info_strategy_id ON vod.topic_info (strategy_id);
CREATE INDEX ix_topic_info_modified_time ON vod.topic_info (modified_time);
CREATE INDEX ix_topic_info_customer_id ON vod.topic_info (customer_id);
CREATE INDEX ix_topic_info_deleted ON vod.topic_info (deleted);
CREATE TABLE IF NOT EXISTS vod.`Basic_Asset` (	id BIGINT NOT NULL AUTO_INCREMENT, 
	customer_id BIGINT, 
	created_time INTEGER NOT NULL, 
	modified_time INTEGER NOT NULL, 
	deleted SMALLINT NOT NULL, 
	vender_id BIGINT NOT NULL, 
	type SMALLINT NOT NULL, 
	ref_id BIGINT NOT NULL, 
	video_play_url VARCHAR(512), 
	video_swf_url VARCHAR(512), 
	video_m3u8_url VARCHAR(512), 
	video_quality VARCHAR(128), 
	fee SMALLINT, 
	video_play_param VARCHAR(1024), 
	image_post_url VARCHAR(1024), 
	image_icon_url VARCHAR(1024), 
	small_image_post_url VARCHAR(1024), 
	small_image_icon_url VARCHAR(1024), 
	vender_update_time VARCHAR(32), 
	vender_category VARCHAR(16), 
	ref_source_id VARCHAR(40), 
	data_source VARCHAR(200), 
	is_only SMALLINT, 
	available SMALLINT NOT NULL, 
	online SMALLINT NOT NULL, 
	PRIMARY KEY (id)
)ENGINE=InnoDB CHARSET=utf8;

CREATE INDEX `ix_Basic_Asset_deleted` ON vod.`Basic_Asset` (deleted);
CREATE INDEX `ix_Basic_Asset_ref_id` ON vod.`Basic_Asset` (ref_id);
CREATE INDEX `ix_Basic_Asset_ref_source_id` ON vod.`Basic_Asset` (ref_source_id);
CREATE INDEX `ix_Basic_Asset_modified_time` ON vod.`Basic_Asset` (modified_time);
CREATE INDEX `ix_Basic_Asset_vender_id` ON vod.`Basic_Asset` (vender_id);
CREATE INDEX `ix_Basic_Asset_customer_id` ON vod.`Basic_Asset` (customer_id);
CREATE INDEX `ix_Basic_Asset_video_quality` ON vod.`Basic_Asset` (video_quality);
