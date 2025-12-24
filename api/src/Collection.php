<?php

declare(strict_types=1);

namespace App\Api;

/**
 * Immutable collection with functional operations.
 *
 * @template T
 */
readonly class Collection implements \JsonSerializable, \IteratorAggregate, \Countable
{
    /**
     * @param array<T> $items
     */
    private function __construct(
        private array $items,
    ) {}

    /**
     * Create a collection from an array.
     *
     * @template U
     *
     * @param array<U> $items
     *
     * @return self<U>
     */
    public static function from(array $items): self
    {
        return new self($items);
    }

    /**
     * Map over items.
     *
     * @template U
     *
     * @param callable(T): U $fn
     *
     * @return self<U>
     */
    public function map(callable $fn): self
    {
        return new self(array_map($fn, $this->items));
    }

    /**
     * Filter items.
     *
     * @param callable(T): bool $fn
     *
     * @return self<T>
     */
    public function filter(callable $fn): self
    {
        return new self(array_values(array_filter($this->items, $fn)));
    }

    /**
     * Get first item matching predicate.
     *
     * @param callable(T): bool $fn
     *
     * @return T|null
     */
    public function first(callable $fn): mixed
    {
        foreach ($this->items as $item) {
            if ($fn($item)) {
                return $item;
            }
        }
        return null;
    }

    /**
     * @return array<T>
     */
    public function toArray(): array
    {
        return $this->items;
    }

    /**
     * @return array<T>
     */
    public function jsonSerialize(): array
    {
        return $this->items;
    }

    /**
     * @return \ArrayIterator<int, T>
     */
    public function getIterator(): \ArrayIterator
    {
        return new \ArrayIterator($this->items);
    }

    public function count(): int
    {
        return count($this->items);
    }
}
