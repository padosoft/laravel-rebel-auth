<?php

declare(strict_types=1);

namespace Padosoft\Rebel\Auth;

use Spatie\LaravelPackageTools\Package;
use Spatie\LaravelPackageTools\PackageServiceProvider;

/**
 * Skeleton iniziale di padosoft/laravel-rebel-auth. Implementazione in arrivo.
 */
final class RebelAuthServiceProvider extends PackageServiceProvider
{
    public function configurePackage(Package $package): void
    {
        $package->name('laravel-rebel-auth');
    }
}
