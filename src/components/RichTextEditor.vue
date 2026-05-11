<template>
  <div class="rte">
    <div v-if="editor" class="rte-toolbar">
      <button
        type="button"
        class="rte-btn"
        :class="{ active: editor.isActive('bold') }"
        @click="editor.chain().focus().toggleBold().run()"
        :disabled="!editor.can().chain().focus().toggleBold().run()"
        title="Kalın (Ctrl+B)"
      ><b>B</b></button>
      <button
        type="button"
        class="rte-btn"
        :class="{ active: editor.isActive('italic') }"
        @click="editor.chain().focus().toggleItalic().run()"
        :disabled="!editor.can().chain().focus().toggleItalic().run()"
        title="İtalik (Ctrl+I)"
      ><i>I</i></button>
      <button
        type="button"
        class="rte-btn"
        :class="{ active: editor.isActive('strike') }"
        @click="editor.chain().focus().toggleStrike().run()"
        title="Üstü çizili"
      ><s>S</s></button>
      <span class="rte-sep" aria-hidden="true"></span>
      <button
        type="button"
        class="rte-btn"
        :class="{ active: editor.isActive('heading', { level: 2 }) }"
        @click="editor.chain().focus().toggleHeading({ level: 2 }).run()"
        title="Başlık 2"
      >H2</button>
      <button
        type="button"
        class="rte-btn"
        :class="{ active: editor.isActive('heading', { level: 3 }) }"
        @click="editor.chain().focus().toggleHeading({ level: 3 }).run()"
        title="Başlık 3"
      >H3</button>
      <span class="rte-sep" aria-hidden="true"></span>
      <button
        type="button"
        class="rte-btn"
        :class="{ active: editor.isActive('bulletList') }"
        @click="editor.chain().focus().toggleBulletList().run()"
        title="Madde işaretli liste"
      >•</button>
      <button
        type="button"
        class="rte-btn"
        :class="{ active: editor.isActive('orderedList') }"
        @click="editor.chain().focus().toggleOrderedList().run()"
        title="Numaralı liste"
      >1.</button>
      <span class="rte-sep" aria-hidden="true"></span>
      <button
        type="button"
        class="rte-btn"
        :class="{ active: editor.isActive('link') }"
        @click="setLink"
        title="Bağlantı ekle/kaldır"
      >🔗</button>
      <button
        type="button"
        class="rte-btn"
        @click="editor.chain().focus().setHorizontalRule().run()"
        title="Yatay çizgi"
      >―</button>
      <span class="rte-sep" aria-hidden="true"></span>
      <button
        type="button"
        class="rte-btn"
        @click="editor.chain().focus().undo().run()"
        :disabled="!editor.can().undo()"
        title="Geri al (Ctrl+Z)"
      >↶</button>
      <button
        type="button"
        class="rte-btn"
        @click="editor.chain().focus().redo().run()"
        :disabled="!editor.can().redo()"
        title="İleri al (Ctrl+Shift+Z)"
      >↷</button>
      <span class="rte-sep" aria-hidden="true"></span>
      <button
        type="button"
        class="rte-btn"
        @click="editor.chain().focus().unsetAllMarks().clearNodes().run()"
        title="Biçimlendirmeyi temizle"
      >⨯</button>
    </div>
    <EditorContent :editor="editor" class="rte-content rich-content" />
  </div>
</template>

<script setup>
import { onBeforeUnmount, watch } from 'vue';
import { useEditor, EditorContent } from '@tiptap/vue-3';
import StarterKit from '@tiptap/starter-kit';
import Link from '@tiptap/extension-link';

const props = defineProps({
  modelValue: { type: String, default: '' },
  placeholder: { type: String, default: '' },
});
const emit = defineEmits(['update:modelValue']);

const editor = useEditor({
  content: props.modelValue || '',
  extensions: [
    StarterKit.configure({
      heading: { levels: [2, 3] },
    }),
    Link.configure({
      openOnClick: false,
      autolink: true,
      HTMLAttributes: { rel: 'noopener noreferrer', target: '_blank' },
    }),
  ],
  onUpdate: ({ editor }) => {
    const html = editor.getHTML();
    // TipTap returns "<p></p>" for empty — normalize to empty string.
    emit('update:modelValue', html === '<p></p>' ? '' : html);
  },
});

watch(
  () => props.modelValue,
  (val) => {
    if (!editor.value) return;
    const current = editor.value.getHTML();
    const normalized = current === '<p></p>' ? '' : current;
    if (normalized === (val || '')) return;
    editor.value.commands.setContent(val || '', false);
  }
);

function setLink() {
  if (!editor.value) return;
  const prev = editor.value.getAttributes('link').href;
  const url = window.prompt('Bağlantı URL (boş bırakırsanız kaldırılır):', prev || 'https://');
  if (url === null) return;
  if (url === '') {
    editor.value.chain().focus().extendMarkRange('link').unsetLink().run();
    return;
  }
  editor.value.chain().focus().extendMarkRange('link').setLink({ href: url }).run();
}

onBeforeUnmount(() => {
  editor.value?.destroy();
});
</script>
