<?php

declare(strict_types=1);

namespace App\Tests\Integration;

use Symfony\Bundle\FrameworkBundle\Test\KernelTestCase;

class KernelIntegrationTest extends KernelTestCase
{
    public function testKernelBootsCorrectly(): void
    {
        $kernel = self::bootKernel();

        // Test that kernel boots without errors
        $this->assertSame('test', $kernel->getEnvironment());

        // Test that container is available
        $container = $kernel->getContainer();
        $this->assertNotNull($container);
    }

    public function testServiceContainer(): void
    {
        self::bootKernel();
        $container = static::getContainer();

        // Test that essential services are available
        $this->assertTrue($container->has('router'));
        $this->assertTrue($container->has('request_stack'));
        $this->assertTrue($container->has('event_dispatcher'));

        // Test our controller service
        $this->assertTrue($container->has('App\Controller\SimpleController'));
    }

    public function testEnvironmentConfiguration(): void
    {
        self::bootKernel();
        $container = static::getContainer();

        // Test environment variables
        $this->assertEquals('test', $container->getParameter('kernel.environment'));
        $this->assertTrue($container->getParameter('kernel.debug'));
    }

    public function testDatabaseConnection(): void
    {
        self::bootKernel();
        $container = static::getContainer();

        // Test that database service is configured (skip if doctrine not fully configured)
        if ($container->has('doctrine')) {
            $doctrine = $container->get('doctrine');
            $this->assertNotNull($doctrine);
        } else {
            $this->markTestSkipped('Doctrine not configured in test environment');
        }
    }
}
