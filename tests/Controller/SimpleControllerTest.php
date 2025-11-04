<?php

declare(strict_types=1);

namespace App\Tests\Controller;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

class SimpleControllerTest extends WebTestCase
{
    public function testHomePage(): void
    {
        $client = static::createClient();
        $crawler = $client->request('GET', '/');

        // Test that the page loads successfully
        $this->assertResponseIsSuccessful();

        // Test that the page contains expected content
        $this->assertSelectorTextContains('h1', 'Simple Xdebug Test');
        $this->assertSelectorExists('.status');
    }

    public function testHomePageContent(): void
    {
        $client = static::createClient();
        $client->request('GET', '/');

        // Test HTTP status
        $this->assertEquals(200, $client->getResponse()->getStatusCode());

        // Test content type
        $this->assertTrue(
            $client->getResponse()->headers->contains(
                'Content-Type',
                'text/html; charset=UTF-8'
            )
        );

        // Test page content
        $content = $client->getResponse()->getContent();
        $this->assertStringContainsString('Hello from Symfony!', $content);
        $this->assertStringContainsString('Xdebug Status:', $content);
    }

    public function testXdebugSessionParameter(): void
    {
        $client = static::createClient();
        $client->request('GET', '/?XDEBUG_SESSION=PHPSTORM');

        $this->assertResponseIsSuccessful();

        // The page should still load normally with Xdebug session parameter
        $content = $client->getResponse()->getContent();
        $this->assertStringContainsString('Simple Xdebug Test', $content);
    }
}
