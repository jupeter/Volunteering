set echo off

drop user vol_admin cascade;

create user vol_admin identified by oracle default tablespace users temporary tablespace temp;

grant connect, resource, dba to vol_admin;

connect vol_admin/oracle



create table address(
/* adresses of users and providers */
	address_id			number
,	email				varchar2(50) 	not null
,	street				varchar2(50)
,	city				varchar2(20)
,	postal_code			varchar2(10)	
,	country				varchar2(20)
,	constraint address_pk	
		primary key (address_id)	
);
create table provider(
/* charities (providers of volunteering programs and offers) */
	provider_id 			number
,	name				varchar2(50) 	not null
,	logo				blob
,	address_id			number
,	constraint provider_pk	
		primary key (provider_id)
,	constraint fk_provider_address
		foreign key (address_id)
		references address(address_id)
);
create table link_type(
/* dictionary of link types eg.: google+, twitter, etc. */		
	link_type_id			number
,	name				varchar2(20) 	not null
,	logo				blob
,	constraint link_type_pk	
		primary key (link_type_id)
);
create table link(
/* links of providers */
	link_id 			number
,	provider_id 			number 		not null
,	link_type_id			number 		not null
,	url				varchar2(150) 	not null
,	constraint link_pk	
		primary key (link_id)
,	constraint fk_provider_link 
		foreign key (provider_id)
		references provider(provider_id)
,	constraint fk_link_type_link
		foreign key (link_type_id)
		references link_type(link_type_id)
);
create table program(
/* programs (sets of offers) created by providers */
	program_id 			number
,	provider_id 			number
,	name				varchar2(50)
,	highlight			varchar2(1) /* ??? */
,	date_to				date 		not null
,	date_from			date
,	status_type_id			number 		not null
,	share_program			varchar2(50) /* ??? */
,	constraint program_pk	
		primary key (program_id)
,	constraint fk_provider_program
		foreign key (provider_id)
		references provider(provider_id)
);
create table offer(
/* offers pertaining to a particular program */
	offer_id 			number
,	program_id 			number 		not null
,	name				varchar2(50)
,	description			varchar2(300)
,	volunteer_type			varchar2(20)
,	init_vac_cnt    		number
,	act_vac_cnt			number
,	status				number 		not null 
,	date_from			date 		not null
,	date_to				date 		not null
,	work_hours_month		date
,	daytime				varchar2(20)
,	workhours			varchar2(20)
,	constraint offer_pk	
		primary key (offer_id)
,	constraint fk_program_offer 
		foreign key (program_id)
		references program(program_id)
, 	constraint chk_status	
		check (status IN ('OPENED','PERMANENT','CLOSED'))
);
create table req_set(
/* requirements for offers */
	req_id				number
,	offer_id			number 		not null
,	is_obligatory			varchar2(1) 	not null
,	constraint req_set_pk	
		primary key (req_id)
,	constraint fk_offer_req_set 
		foreign key (offer_id)
		references offer(offer_id)
, 	constraint chk_is_obligatory	
		check (is_obligatory IN ('Y','N'))
);
create table offer_det_set(
/* details of offers */
	offer_det_set_id		number 		not null
,	offer_id			number 		not null
,	description			varchar2(50)
,	is_valid			varchar2(1) 	not null
,	constraint offer_det_set_pk	
		primary key (offer_det_set_id)
,	constraint fk_offer_offer_det_set 
		foreign key (offer_id)
		references offer(offer_id)
);
create table user_list(
/* list of applicants (ie. users) */
	user_list_id 			number
,	user_type			varchar2(20)
, 	first_name			varchar2(50)
, 	last_name			varchar2(50)
,	login				varchar2(20) 	not null
,	password			varchar2(50) 	not null
,	address_id			number 		not null
,	constraint user_list_pk	
		primary key (user_list_id)
,	constraint fk_address_user_list
		foreign key (address_id)
		references address(address_id)
, 	constraint chk_user_type	
		check (user_type IN ('ADMIN','VOLUNTEER','NOTFORPROFIT','FORPROFIT'))
);
create table appl_set(
/* applications for a particular user, offer with decisions */
	appl_id				number 		not null
,	offer_id			number 		not null
,	user_list_id			number 		not null
,	decision			varchar2(20)
,	feedback			varchar2(50)	
,	constraint appl_set_pk	
		primary key (appl_id)
,	constraint fk_offer_appl_set
		foreign key (offer_id)
		references offer(offer_id)	
,	constraint fk_user_appl_set
		foreign key (user_list_id)
		references user_list(user_list_id)
);
create table doc_set(
/* documents for user applications */
	doc_id		 		number
,	offer_id			number 		not null
,	appl_id				number 		not null
,	doc_file			blob
,	constraint doc_set_pk	
		primary key (doc_id)		
,	constraint fk_offer_doc_set
		foreign key (offer_id)
		references offer(offer_id)	
,	constraint fk_appl_doc_set
		foreign key (appl_id)
		references appl_set(appl_id)		
);



