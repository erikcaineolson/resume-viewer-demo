<?php

declare(strict_types=1);

require_once __DIR__ . '/../src/bootstrap.php';

use App\Api\ResumeRepository;
use App\Api\Router;

$pdo = require __DIR__ . '/../src/database.php';
$repository = new ResumeRepository($pdo);
$router = new Router($repository);

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

$method = $_SERVER['REQUEST_METHOD'];
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

echo $router->handle($method, $path);
