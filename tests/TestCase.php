<?php

declare(strict_types=1);

namespace Padosoft\Rebel\Auth\Tests;

use Illuminate\Foundation\Application;
use Orchestra\Testbench\TestCase as Orchestra;
use Padosoft\Rebel\AdminApi\RebelAdminApiServiceProvider;
use Padosoft\Rebel\AiGuard\RebelAiGuardServiceProvider;
use Padosoft\Rebel\Bridge\Fortify\RebelFortifyBridgeServiceProvider;
use Padosoft\Rebel\Channels\RebelChannelsServiceProvider;
use Padosoft\Rebel\Core\RebelCoreServiceProvider;
use Padosoft\Rebel\EmailOtp\RebelEmailOtpServiceProvider;
use Padosoft\Rebel\Recovery\RebelRecoveryServiceProvider;
use Padosoft\Rebel\Sessions\RebelSessionsServiceProvider;
use Padosoft\Rebel\StepUp\RebelStepUpServiceProvider;

abstract class TestCase extends Orchestra
{
    /**
     * @param  Application  $app
     * @return array<int, class-string>
     */
    protected function getPackageProviders($app): array
    {
        return [
            RebelCoreServiceProvider::class,
            RebelEmailOtpServiceProvider::class,
            RebelFortifyBridgeServiceProvider::class,
            RebelStepUpServiceProvider::class,
            RebelChannelsServiceProvider::class,
            RebelSessionsServiceProvider::class,
            RebelRecoveryServiceProvider::class,
            RebelAiGuardServiceProvider::class,
            RebelAdminApiServiceProvider::class,
        ];
    }

    /**
     * @param  Application  $app
     */
    protected function defineEnvironment($app): void
    {
        $app['config']->set('database.default', 'testing');
        $app['config']->set('app.key', 'base64:'.base64_encode(random_bytes(32)));
        $app['config']->set('rebel-core.peppers', [1 => 'test-pepper']);
        $app['config']->set('rebel-core.pepper_current', 1);
    }
}
