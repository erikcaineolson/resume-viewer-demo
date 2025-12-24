<?php

declare(strict_types=1);

$host = getenv('DB_HOST') ?: 'localhost';
$dbname = getenv('DB_NAME') ?: 'resume';
$user = getenv('DB_USER') ?: 'resume_user';
$pass = getenv('DB_PASS') ?: 'resume_pass';
$driver = getenv('DB_DRIVER') ?: 'pgsql';

$dsn = "{$driver}:host={$host};dbname={$dbname}";

return new PDO($dsn, $user, $pass, [
    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES => false,
]);
