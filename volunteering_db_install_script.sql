set echo on

drop user vol_admin cascade;

create user vol_admin identified by oracle default tablespace users temporary tablespace temp;

grant connect, resource, dba to vol_admin;

connect vol_admin/oracle

drop table provider 		CASCADE CONSTRAINTS purge;
drop table dict_link_type 	CASCADE CONSTRAINTS purge;
drop table link 		CASCADE CONSTRAINTS purge;
drop table dict_status_type 	CASCADE CONSTRAINTS purge;
drop table program 		CASCADE CONSTRAINTS purge;
drop table offer 		CASCADE CONSTRAINTS purge;
drop table requirement_desc 	CASCADE CONSTRAINTS purge;
drop table requirement_set 	CASCADE CONSTRAINTS purge;
drop table offer_detail_set 	CASCADE CONSTRAINTS purge;

drop table document_set 	CASCADE CONSTRAINTS purge;
drop table application_set 	CASCADE CONSTRAINTS purge;
drop table address 		CASCADE CONSTRAINTS purge;
drop table portal_user 		CASCADE CONSTRAINTS purge;

create table provider(
	provider_id 		number
,	name			varchar2(50) not null
,	logo			blob
,	constraint provider_pk	
		primary key (provider_id)
);
create table dict_link_type(
/* slownik, np.: google+, twitter, etc. */		
	link_type_id		number
,	name			varchar2(20) not null
,	logo			blob
,	constraint dict_link_type_pk	
		primary key (link_type_id)
);
create table link(
	link_id 		number
,	provider_id 		number not null
,	link_type_id		number not null
,	url			varchar2(100) not null
,	constraint link_pk	
		primary key (link_id)
,	constraint fk_provider_link 
		foreign key (provider_id)
		references provider(provider_id)
,	constraint fk_link_type_link
		foreign key (link_type_id)
		references dict_link_type(link_type_id)
);
create table dict_status_type(
/* slownik, np.: permanent, closed, opened */
	status_type_id		number
,	name			varchar2(20)
,	constraint status_type_pk	
		primary key (status_type_id)
);
create table program(
	program_id 		number
,	provider_id 		number
,	name			varchar2(50)
,	highlight		varchar2(50) /* nie jestem pewien znaczenia*/
,	date_to			date not null
,	date_from		date
,	status_type_id		number not null
,	share_program		varchar2(50) /* nie jestem pewien znaczenia*/
,	constraint program_pk	
		primary key (program_id)
,	constraint fk_provider_program
		foreign key (provider_id)
		references provider(provider_id)
);
create table requirement_desc(
	requirement_desc_id 	number
,	description		varchar2(50) not null
,	constraint requirement_desc_pk	
		primary key (requirement_desc_id)
);
create table requirement_set(
	requirement_set_id	number not null
,	requirement_desc_id	varchar2(20) not null
,	is_obligatory		varchar2(1) not null
,	constraint requirement_set_pk	
		primary key (requirement_set_id,requirement_desc_id)
, 	constraint chk_is_obligatory	
		check (is_obligatory IN ('Y','N'))
);
create table offer_detail_set(
	offer_detail_set_id	number
,	description		varchar2(50)
,	constraint offer_detail_set_pk	
		primary key (offer_detail_set_id)
);
create table offer(
	offer_id 		number
,	program_id 		number not null
,	name			varchar2(50)
,	description		varchar2(300)
,	volunteer_type		varchar2(5)
,	init_vac_cnt    	number
,	act_vac_cnt		number
,	status_type_id		number not null /* dana oferta moze byc zamknieta mimo, ze jej program moze jeszcze trwac */
,	date_from		date not null
,	date_to			date not null
,	work_hours_month	date
,	daytime			varchar2(20) --!
,	workhours		varchar2(20) --!
,	requirement_set_id	number not null
,	offer_detail_set_id	number not null
,	constraint offer_pk	
		primary key (offer_id)
,	constraint fk_program_offer 
		foreign key (program_id)
		references program(program_id)
,	constraint fk_status_type_offer
		foreign key (status_type_id)
		references dict_status_type(status_type_id)
,	constraint fk_offer_detail_set_offer
		foreign key (offer_detail_set_id)
		references offer_detail_set(offer_detail_set_id)
,	constraint uq_requirement_set_offer
		unique (requirement_set_id)
);

create table document_set(
	document_set_id 	number not null
,	document_id		number not null
,	document_file		blob
,	constraint document_set_pk	
		primary key (document_set_id,document_id)		
);
create table application_set(
	application_set_id	number not null
,	application_id		number not null
,	offer_id		number
,	document_set_id		number
,	decision		varchar2(20)
,	feedback		varchar2(50)	
,	constraint application_set_pk	
		primary key (application_set_id,application_id)	
);
create table address(
	address_id		number
,	email			varchar2(50) not null
,	street			varchar2(50)
,	city			varchar2(20)
,	postal_code		varchar2(10)	
,	country			varchar2(20)
,	constraint address_pk	
		primary key (address_id)	
);
create table portal_user(
	portal_user_id 		number
,	user_type		varchar2(20)
, 	first_name		varchar2(50)
, 	last_name		varchar2(50)
,	login			varchar2(20) not null
,	password		varchar2(20) not null
,	address_id		number not null
,	application_set_id	number
,	document_set_id		number
,	constraint portal_user_pk	
		primary key (portal_user_id)
,	constraint fk_address_portal_user
		foreign key (address_id)
		references address(address_id)
,	constraint uq_application_set_portal_user
		unique (application_set_id)
,	constraint uq_document_set_portal_user
		unique (document_set_id)
, 	constraint chk_user_type	
		check (user_type IN ('ADMIN','VOLUNTEER','NOTFORPROFIT','FORPROFIT'))
);




