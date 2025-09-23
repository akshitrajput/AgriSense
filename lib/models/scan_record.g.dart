// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScanRecordCollection on Isar {
  IsarCollection<ScanRecord> get scanRecords => this.collection();
}

const ScanRecordSchema = CollectionSchema(
  name: r'ScanRecord',
  id: -2239514724671306450,
  properties: {
    r'diseaseName': PropertySchema(
      id: 0,
      name: r'diseaseName',
      type: IsarType.string,
    ),
    r'imagePath': PropertySchema(
      id: 1,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'probability': PropertySchema(
      id: 2,
      name: r'probability',
      type: IsarType.double,
    ),
    r'scanDate': PropertySchema(
      id: 3,
      name: r'scanDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _scanRecordEstimateSize,
  serialize: _scanRecordSerialize,
  deserialize: _scanRecordDeserialize,
  deserializeProp: _scanRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'scanDate': IndexSchema(
      id: -5331970072918017285,
      name: r'scanDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'scanDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _scanRecordGetId,
  getLinks: _scanRecordGetLinks,
  attach: _scanRecordAttach,
  version: '3.1.0+1',
);

int _scanRecordEstimateSize(
  ScanRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.diseaseName.length * 3;
  bytesCount += 3 + object.imagePath.length * 3;
  return bytesCount;
}

void _scanRecordSerialize(
  ScanRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.diseaseName);
  writer.writeString(offsets[1], object.imagePath);
  writer.writeDouble(offsets[2], object.probability);
  writer.writeDateTime(offsets[3], object.scanDate);
}

ScanRecord _scanRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScanRecord();
  object.diseaseName = reader.readString(offsets[0]);
  object.id = id;
  object.imagePath = reader.readString(offsets[1]);
  object.probability = reader.readDouble(offsets[2]);
  object.scanDate = reader.readDateTime(offsets[3]);
  return object;
}

P _scanRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scanRecordGetId(ScanRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scanRecordGetLinks(ScanRecord object) {
  return [];
}

void _scanRecordAttach(IsarCollection<dynamic> col, Id id, ScanRecord object) {
  object.id = id;
}

extension ScanRecordQueryWhereSort
    on QueryBuilder<ScanRecord, ScanRecord, QWhere> {
  QueryBuilder<ScanRecord, ScanRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhere> anyScanDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'scanDate'),
      );
    });
  }
}

extension ScanRecordQueryWhere
    on QueryBuilder<ScanRecord, ScanRecord, QWhereClause> {
  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> scanDateEqualTo(
      DateTime scanDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'scanDate',
        value: [scanDate],
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> scanDateNotEqualTo(
      DateTime scanDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scanDate',
              lower: [],
              upper: [scanDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scanDate',
              lower: [scanDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scanDate',
              lower: [scanDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'scanDate',
              lower: [],
              upper: [scanDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> scanDateGreaterThan(
    DateTime scanDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scanDate',
        lower: [scanDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> scanDateLessThan(
    DateTime scanDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scanDate',
        lower: [],
        upper: [scanDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterWhereClause> scanDateBetween(
    DateTime lowerScanDate,
    DateTime upperScanDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'scanDate',
        lower: [lowerScanDate],
        includeLower: includeLower,
        upper: [upperScanDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScanRecordQueryFilter
    on QueryBuilder<ScanRecord, ScanRecord, QFilterCondition> {
  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'diseaseName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'diseaseName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'diseaseName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diseaseName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      diseaseNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'diseaseName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> imagePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      imagePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> imagePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> imagePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> imagePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> imagePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      probabilityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'probability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      probabilityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'probability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      probabilityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'probability',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      probabilityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'probability',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> scanDateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scanDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition>
      scanDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scanDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> scanDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scanDate',
        value: value,
      ));
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterFilterCondition> scanDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scanDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ScanRecordQueryObject
    on QueryBuilder<ScanRecord, ScanRecord, QFilterCondition> {}

extension ScanRecordQueryLinks
    on QueryBuilder<ScanRecord, ScanRecord, QFilterCondition> {}

extension ScanRecordQuerySortBy
    on QueryBuilder<ScanRecord, ScanRecord, QSortBy> {
  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> sortByDiseaseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseaseName', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> sortByDiseaseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseaseName', Sort.desc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> sortByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> sortByProbabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.desc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> sortByScanDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scanDate', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> sortByScanDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scanDate', Sort.desc);
    });
  }
}

extension ScanRecordQuerySortThenBy
    on QueryBuilder<ScanRecord, ScanRecord, QSortThenBy> {
  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByDiseaseName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseaseName', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByDiseaseNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diseaseName', Sort.desc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByProbabilityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'probability', Sort.desc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByScanDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scanDate', Sort.asc);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QAfterSortBy> thenByScanDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scanDate', Sort.desc);
    });
  }
}

extension ScanRecordQueryWhereDistinct
    on QueryBuilder<ScanRecord, ScanRecord, QDistinct> {
  QueryBuilder<ScanRecord, ScanRecord, QDistinct> distinctByDiseaseName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diseaseName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QDistinct> distinctByProbability() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'probability');
    });
  }

  QueryBuilder<ScanRecord, ScanRecord, QDistinct> distinctByScanDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scanDate');
    });
  }
}

extension ScanRecordQueryProperty
    on QueryBuilder<ScanRecord, ScanRecord, QQueryProperty> {
  QueryBuilder<ScanRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScanRecord, String, QQueryOperations> diseaseNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diseaseName');
    });
  }

  QueryBuilder<ScanRecord, String, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<ScanRecord, double, QQueryOperations> probabilityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'probability');
    });
  }

  QueryBuilder<ScanRecord, DateTime, QQueryOperations> scanDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scanDate');
    });
  }
}
