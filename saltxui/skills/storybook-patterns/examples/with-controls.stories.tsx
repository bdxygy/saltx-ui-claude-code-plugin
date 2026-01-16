import type { Meta, StoryObj } from '@storybook/react';
import { Input } from './Input';

const meta: Meta<typeof Input> = {
  title: 'Components/Input',
  component: Input,
  tags: ['autodocs'],
  argTypes: {
    value: {
      control: 'text',
      description: 'Input value',
    },
    placeholder: {
      control: 'text',
      description: 'Placeholder text',
    },
    type: {
      control: 'select',
      options: ['text', 'email', 'password', 'number'],
      description: 'Input type',
    },
    disabled: {
      control: 'boolean',
      description: 'Disable the input',
    },
    error: {
      control: 'text',
      description: 'Error message',
    },
    label: {
      control: 'text',
      description: 'Input label',
    },
    onChange: {
      action: 'changed',
      description: 'Change handler',
    },
  },
  parameters: {
    layout: 'centered',
  },
};

export default meta;
type Story = StoryObj<typeof Input>;

export const Default: Story = {
  args: {
    placeholder: 'Enter text...',
    type: 'text',
  },
};

export const WithLabel: Story = {
  args: {
    ...Default.args,
    label: 'Username',
  },
};

export const WithValue: Story = {
  args: {
    ...Default.args,
    value: 'Sample text',
  },
};

export const Email: Story = {
  args: {
    ...Default.args,
    type: 'email',
    placeholder: 'user@example.com',
  },
};

export const Password: Story = {
  args: {
    ...Default.args,
    type: 'password',
    placeholder: 'Enter password',
  },
};

export const WithError: Story = {
  args: {
    ...Default.args,
    error: 'This field is required',
  },
};

export const Disabled: Story = {
  args: {
    ...Default.args,
    disabled: true,
  },
};

export const Number: Story = {
  args: {
    ...Default.args,
    type: 'number',
    placeholder: '123',
  },
};
