<?php

declare(strict_types=1);

use Padosoft\Rebel\AiGuard\Detection\AnomalyDetector;
use Padosoft\Rebel\Channels\Routing\VerificationRouter;
use Padosoft\Rebel\Core\Contracts\KeyedHasher;
use Padosoft\Rebel\Recovery\RecoveryCodeManager;
use Padosoft\Rebel\Sessions\SessionManager;
use Padosoft\Rebel\StepUp\RebelStepUp;

/**
 * Smoke test for the meta-package: when every member package is installed and
 * its service provider is registered, the key service of each one must resolve
 * from the container. This proves the suite composes as a whole.
 */
it('wires a service from every member package', function (): void {
    expect(app(KeyedHasher::class))->toBeInstanceOf(KeyedHasher::class)
        ->and(app(RebelStepUp::class))->toBeInstanceOf(RebelStepUp::class)
        ->and(app(VerificationRouter::class))->toBeInstanceOf(VerificationRouter::class)
        ->and(app(SessionManager::class))->toBeInstanceOf(SessionManager::class)
        ->and(app(RecoveryCodeManager::class))->toBeInstanceOf(RecoveryCodeManager::class)
        ->and(app(AnomalyDetector::class))->toBeInstanceOf(AnomalyDetector::class);
});
