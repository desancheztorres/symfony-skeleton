<?php

declare(strict_types=1);

namespace App\Tests\Unit;

use PHPUnit\Framework\TestCase;

class ExampleUnitTest extends TestCase
{
    public function testBasicAssertions(): void
    {
        // Test basic PHP functionality
        $this->assertTrue(true);
        $this->assertIsString('Hello World');
        $this->assertEquals(4, 2 + 2);
    }

    public function testArrayOperations(): void
    {
        $array = ['symfony', 'php', 'docker'];

        $this->assertCount(3, $array);
        $this->assertContains('symfony', $array);
        $this->assertNotContains('laravel', $array);
    }

    public function testStringOperations(): void
    {
        $string = 'Symfony Docker Development';

        $this->assertStringContainsString('Symfony', $string);
        $this->assertStringStartsWith('Symfony', $string);
        $this->assertStringEndsWith('Development', $string);
    }

    /**
     * @dataProvider additionProvider
     */
    public function testMathAddition(int $a, int $b, int $expected): void
    {
        $this->assertEquals($expected, $a + $b);
    }

    public static function additionProvider(): array
    {
        return [
            [1, 1, 2],
            [2, 3, 5],
            [0, 0, 0],
            [-1, 1, 0],
        ];
    }
}
