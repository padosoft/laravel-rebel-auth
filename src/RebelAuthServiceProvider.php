<?php

declare(strict_types=1);

namespace Padosoft\Rebel\Auth;

use Spatie\LaravelPackageTools\Package;
use Spatie\LaravelPackageTools\PackageServiceProvider;

/**
 * Service provider for the padosoft/laravel-rebel-auth meta-package.
 *
 * The meta-package does not register services of its own: its job is to pull in
 * the whole Rebel suite via Composer. Each member package self-registers through
 * its own auto-discovered service provider.
 */
final class RebelAuthServiceProvider extends PackageServiceProvider
{
    public function configurePackage(Package $package): void
    {
        $package->name('laravel-rebel-auth');
    }
}
