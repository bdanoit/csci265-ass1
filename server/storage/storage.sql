create table if not exists `users`(`id` varchar(16) not null primary key);
create table if not exists `user_passwords`(`user_id` varchar(16) not null,`password` varchar(12) not null,foreign key (`user_id`) references `users`(`id`) on delete cascade);
