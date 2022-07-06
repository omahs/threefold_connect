<template>
    <div class="min-h-screen bg-white md:block flex justify-center items-center">
        <img
            class="absolute left-2 top-2 w-20 h-20 lg:w-40 lg:h-40 md:filter-whiteout"
            src="https://threefold.io/assets/static/tft_color_logo.3e8a41b.7b655c36cc78de99d8ef9da582b8cc8c.svg"
            alt=""
        />
        <div class="grid md:grid-cols-2">
            <div class="hidden md:block h-screen">
                <img src="/side.jpg" alt="" class="h-full w-full object-cover object-center" />
            </div>
            <div class="md:w-3/5 mx-auto px-8 md:px-0">
                <div class="flex items-center h-full">
                    <div class="flex flex-col">
                        <slot name="content"></slot>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script lang="ts" setup></script>
