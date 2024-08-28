# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UpdateValuesAll::Adapters::Postgres do
  it 'updates attributes' do
    User.create!(id: 1, state: 'pending')
    User.create!(id: 2, state: 'pending')

    changed_ids =
      User.update_values_all(
        [{ id: 1, state: 'confirmed' }, { id: 2, state: 'blocked' }],
        key_to_match: :id,
      )

    expect(changed_ids).to eq [1, 2]
    expect(User.order(:id).pluck(:state)).to eq(%w[confirmed blocked])
  end

  it 'skips update if empty data' do
    changes_ids = User.update_values_all([], key_to_match: :id)
    expect(changes_ids).to eq([])
  end

  it 'fills updated_at' do
    user = User.create!(id: 1, updated_at: 5.days.ago)

    expect {
      User.update_values_all([{ id: 1, name: 'Ivanov' }], key_to_match: :id)
    }.to change { user.reload.updated_at }
  end

  it 'updates data by specified key' do
    User.create!(name: 'Ivanov', state: 'pending')
    User.create!(name: 'Petrov', state: 'pending')

    User.update_values_all(
      [{ name: 'Ivanov', state: 'confirmed' }, { name: 'Petrov', state: 'blocked' }],
      key_to_match: :name,
    )

    expect(User.order(:id).pluck(:state)).to eq(%w[confirmed blocked])
  end

  it 'updates json data' do
    User.create!(id: 1, city: 'Moscow')
    User.create!(id: 2, city: 'Vladivostok')

    User.update_values_all(
      [{ id: 1, address: { city: 'Berlin' } }, { id: 2, address: { city: 'London' } }],
      key_to_match: :id,
    )

    expect(User.order(:id).map(&:city)).to eq(%w[Berlin London])
  end

  it 'fills NULL' do
    user = User.create!(id: 1, name: 'Petrov')

    expect {
      User.update_values_all([{ id: 1, name: nil }], key_to_match: :id)
    }.to change { user.reload.name }.to(nil)
  end

  it 'casts types' do
    user = User.create!(id: 1)

    expect {
      User.update_values_all([{ id: 1, state: 1 }], key_to_match: :id)
    }.to change { user.reload.state }.to('1')
  end

  context 'when method params invalid' do
    it 'raise exception if keys are different' do
      updated = [
        { id: 1, state: 'confirmed' },
        { id: 2, name: 'Petrov' },
      ]

      expect {
        User.update_values_all(updated, key_to_match: :id)
      }.to raise_error(KeyError)
    end

    it 'raise exception if data contains different number of keys' do
      updated = [
        { id: 1, state: 'confirmed', name: 'Ivanov' },
        { id: 2, name: 'Petrov' },
      ]

      expect {
        User.update_values_all(updated, key_to_match: :id)
      }.to raise_error(KeyError)

      expect {
        User.update_values_all(updated.reverse, key_to_match: :id)
      }.to raise_error(KeyError)
    end
  end

  context 'when attributes not changed' do
    let!(:user) { User.create!(id: 1, state: 'pending') }

    it 'does not update record' do
      expect {
        User.update_values_all([{ id: 1, state: 'pending' }], key_to_match: :id)
      }.not_to change { user.reload.updated_at }
    end

    it 'forces update_at' do
      expect {
        User.update_values_all([{ id: 1, state: 'pending' }], key_to_match: :id, touch: true)
      }.to change { user.reload.updated_at }
    end
  end

  it 'updates data by primary key if key_to_match is not specified' do
    User.create!(id: 1, state: 'pending')
    User.create!(id: 2, state: 'pending')

    User.update_values_all([{ id: 1, state: 'confirmed' }, { id: 2, state: 'blocked' }])

    expect(User.order(:id).pluck(:state)).to eq(%w[confirmed blocked])
  end
end
