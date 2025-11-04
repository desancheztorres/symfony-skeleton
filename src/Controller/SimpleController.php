<?php

declare(strict_types=1);

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class SimpleController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(): Response
    {
        // PUT BREAKPOINT HERE
        $message = 'Hello from Symfony!';
        $xdebug_status = extension_loaded('xdebug') ? 'loaded' : 'not loaded';

        // Simple HTML response without templates
        $html = <<<HTML
<!DOCTYPE html>
<html>
<head>
    <title>Simple Debug Test</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .status { padding: 10px; border-radius: 5px; margin: 10px 0; }
        .success { background: #d4edda; color: #155724; }
        .warning { background: #fff3cd; color: #856404; }
    </style>
</head>
<body>
    <h1>Simple Xdebug Test</h1>
    <div class="status {$this->getStatusClass($xdebug_status)}">
        <strong>Xdebug Status:</strong> {$xdebug_status}
    </div>
    <div class="status success">
        <strong>Message:</strong> {$message}
    </div>
    <p>Set a breakpoint in <code>src/Controller/SimpleController.php</code> line 15</p>
</body>
</html>
HTML;

        return new Response($html);
    }

    private function getStatusClass(string $status): string
    {
        return $status === 'loaded' ? 'success' : 'warning';
    }
}
