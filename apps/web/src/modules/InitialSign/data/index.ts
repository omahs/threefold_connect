import { ref, Ref } from 'vue';
import { useLocalStorage } from '@vueuse/core';
import { nanoid } from 'nanoid';

export const friendlyName = ref<string>();
export const isJson = ref<boolean>();
export const dataHash = ref<string>();
export const dataUrl = ref<string>();
